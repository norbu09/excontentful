defmodule Excontentful.Management.ContentTypes do

  use Tesla
  require Logger

  plug Tesla.Middleware.ParseResponse, %{type: :raw}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/octet-stream", "application/vnd.contentful.management.v1+json"]

  def get_all(config) do
    c = Excontentful.Helper.client(:mgmt, config)
    res = get(c, "content_types")
    {res, c}
  end

  def save_local(config) do
    case get_all(config) do
      {{:ok, items}, _} ->
        items["items"]
        |> Enum.each(&(save(config.schema_dir, &1)))
        {{:ok, :saved}, config}
      error -> error
    end
  end

  def load_local(config) do
    case File.ls(config.schema_dir) do
      {:ok, files} ->
        data = Enum.map(files, &(load(config, &1)))
        {{:ok, data}, config}
      error -> error
    end
  end

  defp load(config, file) do
    with {:ok, json}  <- File.read("#{config.schema_dir}/#{file}"),
         {:ok, entry} <- Poison.decode(json),
         # :ok          <- Logger.debug("Entry: #{inspect entry, pretty: :true}"),
         c            <- Excontentful.Helper.client(:mgmt, config, %{"X-Contentful-Version" => entry["sys"]["version"]}),
         {:ok, res}   <- put(c, "content_types/#{entry["sys"]["id"]}", entry),
    do: {:ok, res}
  end

  defp save(dir, item) do
    name = "#{dir}/#{item["sys"]["id"]}.json"
    Logger.debug("Saving to #{name}")
    case File.mkdir_p(dir) do
      :ok ->
        with {:ok, file} <- File.open(name, [:write, :utf8]),
             {:ok, json} <- Poison.encode_to_iodata(item, pretty: :true),
             :ok         <- IO.write(file, json),
             :ok         <- File.close(file),
        do:  {:ok, :saved}
      error -> error
    end
  end

end
