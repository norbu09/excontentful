defmodule Excontentful.Delivery.Asset do

  use Tesla
  require Logger

  plug Tesla.Middleware.ParseResponse, %{type: :entry}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def get?(config, id) do
    c = Excontentful.Helper.client(:delivery, config)
    res = Excontentful.Helper.cached?(id, fn() -> 
      Logger.debug("cache miss for #{id}")
      get(c, "/assets/#{id}") 
    end)
    {res, c}
  end
  
end
