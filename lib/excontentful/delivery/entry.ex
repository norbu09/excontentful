defmodule Excontentful.Delivery.Entry do

  use Tesla
  require Logger

  plug Tesla.Middleware.ParseResponse, %{type: :entry}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def get?(config, id) do
    c = Excontentful.Helper.client(:delivery, config)
    res = Excontentful.Helper.cached?(id, fn() -> 
      Logger.debug("cache miss for #{id}")
      get(c, "/entries/#{id}") 
    end)
    {res, c}
  end

  # this only respects the first found vs the `entries` version
  def search(config, type, field, value) do
    c = Excontentful.Helper.client(:delivery, config)
    path = Enum.join([type, field, value], "/")
    res = Excontentful.Helper.cached?(path, fn() -> 
      Logger.debug("cache miss for #{path}")
      get(c, "/entries", query: [content_type: type, "fields.#{field}": value])
    end)
    {res, c}
  end

end
