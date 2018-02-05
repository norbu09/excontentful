defmodule Excontentful.Delivery.Entry do

  use Tesla

  plug Tesla.Middleware.ParseResponse, %{type: :entry}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def get?(config, id) do
    c = client(config)
    res = get(c, "/entries/#{id}")
    {res, c}
  end

  # this only respects the first found vs the `entries` version
  def search(config, type, field, value) do
    c = client(config)
    res = get(c, "/entries", query: [content_type: type, "fields.#{field}": value])
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
