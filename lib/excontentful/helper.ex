defmodule Excontentful.Helper do

  use Tesla
  
  def cached?(path, fun) do
    ConCache.get_or_store(:content, path, fun)
  end
  
  def client(:delivery, config, type) do
    case config[:client] do
      nil ->
        Tesla.build_client [
          {Tesla.Middleware.ParseContentfulResponse, %{type: type}},
          {Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]},
          {Tesla.Middleware.BaseUrl, "https://cdn.contentful.com/spaces/#{config.space}"},
          {Tesla.Middleware.Headers, %{"Authorization" => "Bearer #{config.token}", "User-Agent" => "exContentful"}}
        ]
     client -> client
    end
  end
  def client(:mgmt, config, header \\ %{}) do
    h = Map.merge(%{"Authorization" => "Bearer #{config.mgmt_token}", "User-Agent" => "exContentful"}, header)
    case config[:client] do
      nil ->
        Tesla.build_client [
          {Tesla.Middleware.ParseContentfulResponse, %{type: :raw}},
          {Tesla.Middleware.JSON, decode_content_types: ["application/octet-stream", "application/vnd.contentful.delivery.v1+json"]},
          {Tesla.Middleware.BaseUrl, "https://api.contentful.com/spaces/#{config.space}"},
          {Tesla.Middleware.Headers, h}
        ]
     client -> client
    end
  end
end
