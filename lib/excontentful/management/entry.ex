defmodule Excontentful.Management.Entry do

  use Tesla

  @token System.get_env("CONTENTFUL_MANAGEMENT_TOKEN") || Application.get_env(:excontentful, :mgmt_token)
  @space System.get_env("CONTENTFUL_SPACE") || Application.get_env(:excontentful, :space)

  require Logger

  plug Tesla.Middleware.ParseResponse, %{type: :raw}
  plug Tesla.Middleware.BaseUrl, "https://api.contentful.com/spaces/#{@space}"
  plug Tesla.Middleware.Headers, %{ "Authorization" => "Bearer #{@token}", "User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/octet-stream", "application/vnd.contentful.management.v1+json"]

  def update(entry) do
    put("/entries/#{entry["sys"]["id"]}", entry)
  end

  def publish(id) do
    {:ok, entry} = get("/entries/#{id}")
    # Logger.debug("Entry: #{inspect entry}")
    put("/entries/#{id}/published", "", [{"X-Contentful-Version", entry["sys"]["version"]}])
  end

  def unpublish(id) do
    delete("/entries/#{id}/published")
  end

  def del(id) do
    delete("/entries/#{id}")
  end

end
