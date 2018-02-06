defmodule Excontentful.Management.Entry do

  use Tesla
  require Logger

  plug Tesla.Middleware.ParseResponse, %{type: :raw}
  plug Tesla.Middleware.Headers, %{"User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/octet-stream", "application/vnd.contentful.management.v1+json"]

  def update(config, entry) do
    c = Excontentful.Helper.client(:mgmt, config)
    res = put(c, "/entries/#{entry["sys"]["id"]}", entry)
    {res, c}
  end

  def publish(config, id) do
    c = Excontentful.Helper.client(:mgmt, config)
    case get(c, "/entries/#{id}") do
      {:ok, entry} ->
        # Logger.debug("Entry: #{inspect entry}")
        c1 = Excontentful.Helper.client(:mgmt, config, %{"X-Contentful-Version" => entry["sys"]["version"]})
        res = put(c1, "/entries/#{id}/published", "")
        {res, c}
      error -> error
    end
  end

  def unpublish(config, id) do
    c = Excontentful.Helper.client(:mgmt, config)
    res = delete(c, "/entries/#{id}/published")
    {res, c}
  end

  def del(config, id) do
    c = Excontentful.Helper.client(:mgmt, config)
    res = delete(c, "/entries/#{id}")
    {res, c}
  end

end
