defmodule Excontentful.Delivery.Asset do

  use Tesla
  require Logger

  plug Tesla.Middleware.ParseContentfulResponse, %{type: :entry}

  def get?(config, id) do
    c = Excontentful.Helper.client(:delivery, config)
    res = Excontentful.Helper.cached?(id, fn() -> 
      Logger.debug("cache miss for #{id}")
      get(c, "/assets/#{id}") 
    end)
    {res, c}
  end
  
end
