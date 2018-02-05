defmodule Excontentful do
  @moduledoc """
  Excontentful is an easy way to work with contentful in a opnionated way. It
  tries to abstract away API decisions that users may not be interesd in. It
  also tries to establish some common defaults 
  """
  use GenServer
  require Logger

  def start_link([], default) do
    start_link(default)
  end
  def start_link(default) do
    GenServer.start_link(__MODULE__, default, [name: __MODULE__])
  end

  def init(_args) do
    # get config and put it in the state
    space      = System.get_env("CONTENTFUL_SPACE") || Application.get_env(:excontentful, :space)
    token      = System.get_env("CONTENTFUL_TOKEN") || Application.get_env(:excontentful, :token)
    mgmt_token = System.get_env("CONTENTFUL_MANAGEMENT_TOKEN") || Application.get_env(:excontentful, :mgmt_token)
    prev_token = System.get_env("CONTENTFUL_PREVIEW_TOKEN") || Application.get_env(:excontentful, :prev_token)
    config = %{space: space, token: token, mgmt_token: mgmt_token, prev_token: prev_token}
    Logger.debug("Started Contentful interface...")
    {:ok, %{config: config}}
  end

  @doc """
  Entries calls
  -------------

  These calls deal with many entries and will always return a list.
  """
  def entries do
    GenServer.call(__MODULE__, :entries)
  end

  def entries(content_type) do
    GenServer.call(__MODULE__, {:entries, content_type})
  end

  def entries(content_type, options) do
    GenServer.call(__MODULE__, {:entries, content_type, options})
  end

  def search_entries(content_type, query) do
    GenServer.call(__MODULE__, {:search_entries, content_type, query})
  end

  @doc """
  Entry calls
  -------------

  These calls deal with a single entry and will always return a map.
  """
  def get_entry(id) do
    GenServer.call(__MODULE__, {:entry, id})
  end

  def get_entry_prev(id) do
    GenServer.call(__MODULE__, {:entry_prev, id})
  end

  def update_entry(entry) do
    GenServer.call(__MODULE__, {:update_entry, entry})
  end

  def publish_entry(id) do
    GenServer.call(__MODULE__, {:publish_entry, id})
  end

  def unpublish_entry(id) do
    GenServer.call(__MODULE__, {:unpublish_entry, id})
  end

  def delete_entry(id) do
    GenServer.call(__MODULE__, {:delete_entry, id})
  end

  def search_entry(content_type, field, value) do
    GenServer.call(__MODULE__, {:search_entry, content_type, field, value})
  end

  def search_entry_prev(content_type, field, value) do
    GenServer.call(__MODULE__, {:search_entry_prev, content_type, field, value})
  end

  @doc """
  Internal implementation below the fold
  """

  def handle_call(:entries, _from, state) do
    {response, client} = Excontentful.Delivery.Entries.all(state.config)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:entries, type}, _from, state) do
    {response, client} = Excontentful.Delivery.Entries.by_content(state.config, type)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:entries, type, options}, _from, state) do
    {response, client} = Excontentful.Delivery.Entries.by_content(state.config, type, options)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:search_entries, type, query}, _from, state) do
    {response, client} = Excontentful.Delivery.Entries.search(state.config, type, query)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:entry, id}, _from, state) do
    {response, client} = Excontentful.Delivery.Entry.get?(state.config, id)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:entry_prev, id}, _from, state) do
    {response, client} = Excontentful.Preview.Entry.get?(state.config, id)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:update_entry, entry}, _from, state) do
    {response, client} = Excontentful.Management.Entry.update(state.config, entry)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:publish_entry, id}, _from, state) do
    {response, client} = Excontentful.Management.Entry.publish(state.config, id)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:unpublish_entry, id}, _from, state) do
    {response, client} = Excontentful.Management.Entry.unpublish(state.config, id)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:delete_entry, id}, _from, state) do
    {response, client} = Excontentful.Management.Entry.del(state.config, id)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:search_entry, content_type, field, value}, _from, state) do
    {response, client} = Excontentful.Delivery.Entry.search(state.config, content_type, field, value)
    {:reply, response, Map.put(state, "client", client)}
  end

  def handle_call({:search_entry_prev, content_type, field, value}, _from, state) do
    {response, client} = Excontentful.Preview.Entry.search(state.config, content_type, field, value)
    {:reply, response, Map.put(state, "client", client)}
  end


end
