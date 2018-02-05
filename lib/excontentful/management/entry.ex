defmodule Excontentful.Management.Entry do

  use Tesla

  require Logger

  plug Tesla.Middleware.ParseResponse, %{type: :raw}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/octet-stream", "application/vnd.contentful.management.v1+json"]

  def update(config, entry) do
    c = client(config)
    res = put(c, "/entries/#{entry["sys"]["id"]}", entry)
    {res, c}
  end

  def publish(config, id) do
    c = client(config)
    case get(c, "/entries/#{id}") do
      {:ok, entry} ->
        # Logger.debug("Entry: #{inspect entry}")
        res = put(c, "/entries/#{id}/published", "", [{"X-Contentful-Version", entry["sys"]["version"]}])
        {res, c}
      error -> error
    end
  end

  def unpublish(config, id) do
    c = client(config)
    res = delete(c, "/entries/#{id}/published")
    {res, c}
  end

  def del(config, id) do
    c = client(config)
    res = delete(c, "/entries/#{id}")
    {res, c}
  end

  defp client(config) do
    case config[:client] do
      nil ->
        Tesla.build_client [
          {Tesla.Middleware.BaseUrl, "https://api.contentful.com/spaces/#{config.space}"},
          {Tesla.Middleware.Headers, %{ "Authorization" => "Bearer #{config.mgmt_token}"}}
        ]
     client -> client
    end
  end
end
