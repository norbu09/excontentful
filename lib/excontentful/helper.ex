defmodule Excontentful.Helper do

  use Tesla
  
  def cached?(path, fun) do
    ConCache.get_or_store(:content, path, fun)
  end
  
  def client(:delivery, config) do
    case config[:client] do
      nil ->
        Tesla.build_client [
          {Tesla.Middleware.BaseUrl, "https://cdn.contentful.com/spaces/#{config.space}"},
          {Tesla.Middleware.Headers, %{ "Authorization" => "Bearer #{config.token}"}}
        ]
     client -> client
    end
  end

end
