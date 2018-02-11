defmodule Excontentful.Delivery.Asset do

  use Tesla
  require Logger


  def get?(config, id) do
    c = Excontentful.Helper.client(:delivery, config, :entry)
    res = Excontentful.Helper.cached?(id, fn() -> 
      Logger.debug("cache miss for #{id}")
      get(c, "/assets/#{id}") 
    end)
    {res, c}
  end
  
end
