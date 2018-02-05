defmodule Excontentful.Delivery.Asset do

  use Tesla

  plug Tesla.Middleware.ParseResponse, %{type: :entry}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def get?(config, id) do
    c = client(config)
    res = get(c, "/assets/#{id}")
    {res, c}
  end

  defp client(config) do
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
