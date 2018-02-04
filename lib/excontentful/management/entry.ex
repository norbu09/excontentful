defmodule Excontentful.Management.Entry do

  use Tesla

  @token System.get_env("CONTENTFUL_TOKEN") || Application.get_env(:excontentful, :token)
  @space System.get_env("CONTENTFUL_SPACE") || Application.get_env(:excontentful, :space)

  plug Tesla.Middleware.ParseResponse, %{type: :raw}
  plug Tesla.Middleware.BaseUrl, "https://api.contentful.com/spaces/#{@space}"
  plug Tesla.Middleware.Headers, %{ "Authorization" => "Bearer #{@token}", "User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def update(entry) do
    put("/spaces/#{@space}/entries/#{entry["sys"]["id"]}", entry)
  end

  def publish(id) do
    put("/spaces/#{@space}/entries/#{id}/published", "")
  end

  def unpublish(id) do
    delete("/spaces/#{@space}/entries/#{id}/published")
  end

  def del(id) do
    delete("/spaces/#{@space}/entries/#{id}")
  end
  
end
