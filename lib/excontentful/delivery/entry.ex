defmodule Excontentful.Delivery.Entry do

  use Tesla

  @token System.get_env("CONTENTFUL_TOKEN") || Application.get_env(:excontentful, :token)
  @space System.get_env("CONTENTFUL_SPACE") || Application.get_env(:excontentful, :space)

  plug Tesla.Middleware.ParseResponse, %{type: :entry}
  plug Tesla.Middleware.BaseUrl, "https://cdn.contentful.com/spaces/#{@space}"
  plug Tesla.Middleware.Headers, %{ "Authorization" => "Bearer #{@token}",
    "User-Agent" => "exContentful"} 
  plug Tesla.Middleware.JSON, decode_content_types: ["application/vnd.contentful.delivery.v1+json"]

  def get?(id) do
    get("/entries/#{id}")
  end

  def search(type, field, value) do
    get("/entries?content_type=#{type}&fields.#{field}=#{value}")
  end
  
  
end
