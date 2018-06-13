defmodule Excontentful.Preview.Entry do

  use Tesla

  plug Tesla.Middleware.ParseContentfulResponse, %{type: :entry}
  plug Tesla.Middleware.Headers, [{"User-Agent", "exContentful"}]
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def get?(config, id) do
    c = client(config)
    res = get(c, "/entries/#{id}")
    {res, c}
  end

  def search(config, type, field, value) do
    c = client(config)
    res = get(c, "/entries", query: [content_type: type, "fields.#{field}": value])
    {res, c}
  end
  
  defp client(config) do
    case config[:client] do
      nil ->
        Tesla.build_client [
          {Tesla.Middleware.BaseUrl, "https://preview.contentful.com/spaces/#{config.space}"},
          {Tesla.Middleware.Headers, [{ "Authorization", "Bearer #{config.prev_token}"}]}
        ]
     client -> client
    end
  end
  
end
