defmodule Excontentful.Management do

  use Tesla

  @token System.get_env("CONTENTFUL_TOKEN") || Application.get_env(:excontentful, :token)
  @space System.get_env("CONTENTFUL_SPACE") || Application.get_env(:excontentful, :space)

  plug Tesla.Middleware.ParseResponse
  plug Tesla.Middleware.BaseUrl, "https://api.contentful.com"
  plug Tesla.Middleware.Headers, %{ "Authorization" => "Bearer #{@token}",
    "User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def update_entry(entry) do
    put("/spaces/#{@space}/entries/#{entry["sys"]["id"]}", entry)
  end

  def publish_entry(id) do
    put("/spaces/#{@space}/entries/#{id}/published", "")
  end

  def unpublish_entry(id) do
    delete("/spaces/#{@space}/entries/#{id}/published")
  end

  def delete_entry(id) do
    delete("/spaces/#{@space}/entries/#{id}")
  end
  
end
