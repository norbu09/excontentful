defmodule Excontentful.Delivery.Entries do

  use Tesla
  require Logger

  plug Tesla.Middleware.ParseContentfulResponse, %{type: :entries}

  def all(config) do
    process(config, "all")
  end

  def by_content(config, type) do
    process(config, type, query: [content_type: type])
  end

  def by_content(config, type, opts) do
    path = type <> List.foldl(opts, "", fn({_, x}, acc) -> Enum.join([acc, x], "/") end)
    process(config, path, query: [content_type: type] ++ opts)
  end

  def search(config, type, query) do
    path = type <> List.foldl(query, "", fn({_, x}, acc) -> Enum.join([acc, x], "/") end)
    process(config,  path, query: [content_type: type, query: query])
  end

  defp process(config, path, opts \\ []) do
    c = Excontentful.Helper.client(:delivery, config)
    res = Excontentful.Helper.cached?(path, fn() -> 
      Logger.debug("cache miss for #{path}")
      get(c, "/entries", opts)
    end)
    {res, c}
  end

  
end
