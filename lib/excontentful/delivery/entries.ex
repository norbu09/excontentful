defmodule Excontentful.Delivery.Entries do

  use Tesla

  plug Tesla.Middleware.ParseResponse, %{type: :entries}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def all(config) do
    process(config)
  end

  def by_content(config, type) do
    process(config, query: [content_type: type])
  end

  def by_content(config, type, opts) do
    process(config, query: [content_type: type] ++ opts)
  end

  def search(config, type, query) do
    process(config,  query: [content_type: type, query: query])
  end

  defp process(config, opts \\ []) do
    c = client(config)
    res = get(c, "/entries", opts)
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
