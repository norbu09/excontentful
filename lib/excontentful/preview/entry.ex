defmodule Excontentful.Preview.Entry do

  use Tesla

  @token System.get_env("CONTENTFUL_PREVIEW_TOKEN") || Application.get_env(:excontentful, :prev_token)
  @space System.get_env("CONTENTFUL_SPACE") || Application.get_env(:excontentful, :space)

  plug Tesla.Middleware.ParseResponse, %{type: :entry}
  plug Tesla.Middleware.BaseUrl, "https://preview.contentful.com/spaces/#{@space}"
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
