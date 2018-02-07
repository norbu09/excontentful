# Excontentful

ExContentful is a module to interface with
(Contentful)[https://contentful.com]. Contentful is a powerful hosted CMS that
exposes content via a JSON API. 

I normally implement only the bits of an API that I need right now and then
grow it over time so this will most definitely miss functionality till I either
need it myself or get PRs for it. Contributions (any kind incl how to make it
better) gratefully received :)

## Usage

Make sure you add `:excontentful` to your `apps` section like so:

```elixir
applications: [:excontentful]
```

Next define your various token as Contentful distinguishes between different
APIs and has token for all of them. For nor the `space_id` and various token
are limited to one set. this limitation is just how I currently use Contentful
but can be extended in the future if needed (PRs welcome)

```elixir
config :excontentful,
  space: "SPACE_ID",
  token: "CONTENT_DELIVERY_TOKEN",
  prev_token: "CONTENT_PREVIEW_TOKEN",
  mgmt_token: "CONTENT_MANAGEMENT_TOKEN"
```

All set, just fire off queries and get back data:


```elixir
{:ok, entry} = Excontentful.get_entry(ID)
{:ok, entry} = Excontentful.search_entry(CONTENT_TYPE, FIELD_NAME, FIELD_VALUE)
{:ok, entry} = Excontentful.search_entry_prev(CONTENT_TYPE, FIELD_NAME, FIELD_VALUE)
{:ok, entry} = Excontentful.publish_entry(ID)

{:ok, entries} = Excontentful.entries(CONTENT_TYPE)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `excontentful` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:excontentful, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/excontentful](https://hexdocs.pm/excontentful).

