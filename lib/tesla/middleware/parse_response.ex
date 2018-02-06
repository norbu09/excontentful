defmodule Tesla.Middleware.ParseResponse do

  require Logger

  def call(env, next, options) do
    env
    |> Tesla.run(next)
    |> parse(options)
  end

  # parser types
  defp parse(:entry, %{"items" => items} = body) do
    # Logger.debug("RAW: #{inspect body}")
    item(List.first(items), body["includes"], body["errors"])
  end
  defp parse(:entry, item) do
    item(item, nil, nil)
  end

  defp parse(:entries, body) do
    body["items"]
    |> Enum.reduce([], fn(x, acc) -> acc ++ [ item(x, body["includes"], body["errors"])] end)
  end

  defp parse(:raw, body) do
    body
  end

  defp parse(res, options) do
    case res.status do
      200 -> {:ok, parse(options.type, res.body)}
      _   -> {:error, %{"error" => res.body}}
    end
  end

  defp item(itm, includes, errors) do
    itm2 = itm
    |> Map.put("includes", includes)
    |> Map.put("errors", errors)
    resolve(itm2)
  end

  defp resolve(item) do
    item["fields"]
    |> resolve_includes(:asset, item["includes"])
    |> resolve_includes(:error, item["errors"])
    |> Map.put("sys", item["sys"])
  end


  # includes handling
  defp resolve_includes(fields, type, includes) do
    fields
    |> Enum.reduce(%{}, fn(x, z) -> 
      {k, v} = resolve_include(type, x, includes)
      Map.put(z, k, v) end)
  end
  defp resolve_include(type, {key, val}, includes) when is_list(val) do
    res = val
          |> Enum.map(fn(x) -> resolve_include(type, {key, x}, includes) end)
          |> Enum.reduce([], fn({_, y}, acc) -> acc ++ [y] end)
  {key, res}
  end
  defp resolve_include(:asset, {key, %{"sys" => %{"type" => "Link", "linkType" => "Asset", "id" => id}} = val}, includes) do
    # Logger.debug("resolve assets: #{inspect includes} - ID: #{id}")
    {key, resolve_include(:asset, includes["Asset"], id, val)}
  end
  defp resolve_include(:asset, {key, %{"sys" => %{"type" => "Link", "linkType" => "Entry", "id" => id}} = val}, includes) do
    {key, resolve_include(:asset, includes["Entry"], id, val)}
  end
  defp resolve_include(:error, {key, %{"sys" => %{"id" => id}} = val}, errors) do
    # Logger.error("ERROR: #{inspect errors}")
    {key, resolve_include(:error, errors, id, val)}
  end
  defp resolve_include(_type, tuple, _includes) do
    tuple
  end
  defp resolve_include(:asset, nil, id, _val) do
    fetch_asset(id)
  end
  defp resolve_include(:asset, includes, id, _val) do
    case Enum.find(includes, fn(x) -> x["sys"]["id"] == id end) do
      nil -> fetch_asset(id)
      res -> 
        # Logger.debug("resolve entry: #{inspect res} - ID: #{id}")
        resolve(res)
    end
  end
  defp resolve_include(:error, nil, _id, val) do
    val
  end
  defp resolve_include(:error, errors, id, val) when is_list(errors) do
    # Logger.error("ERROR: #{inspect errors}")
    case Enum.find(errors, fn(x) -> x["details"]["id"] == id end) do
      nil -> val
      err -> %{ "error" => err }
    end
  end

  def fetch_asset(id) do
    Logger.debug("Fetching asset: #{id}")
    case Excontentful.get_asset(id) do
      {:ok, asset}  -> asset
      {:error, err} -> err
    end
  end

end
