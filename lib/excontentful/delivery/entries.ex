defmodule Excontentful.Delivery.Entries do

  use Tesla

  @token System.get_env("CONTENTFUL_TOKEN") || Application.get_env(:excontentful, :token)
  @space System.get_env("CONTENTFUL_SPACE") || Application.get_env(:excontentful, :space)

  plug Tesla.Middleware.ParseResponse, %{type: :entries}
  plug Tesla.Middleware.BaseUrl, "https://cdn.contentful.com/spaces/#{@space}"
  plug Tesla.Middleware.Headers, %{ "Authorization" => "Bearer #{@token}",
    "User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def all do
    get("/entries")
  end

  def by_content(type) do
    get("/entries", query: [content_type: type])
  end

  def by_content(type, opts) do
    query = [content_type: type] ++ opts
    get("/entries", query: query)
  end

  def search(type, query) do
    get("/entries", query: [content_type: type, query: query])
  end
  
end
