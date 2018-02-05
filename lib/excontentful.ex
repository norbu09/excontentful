defmodule Excontentful do
  @moduledoc """
  Excontentful is an easy way to work with contentful in a opnionated way. It
  tries to abstract away API decisions that users may not be interesd in. It
  also tries to establish some common defaults 
  """
  require Logger

  @doc """
  Entries calls
  -------------

  These calls deal with many entries and will always return a list.
  """
  def entries do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.entries(pid)
    GenServer.stop(pid)
    res
  end

  def entries(content_type) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.entries(pid, content_type)
    GenServer.stop(pid)
    res
  end

  def entries(content_type, options) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.entries(pid, content_type, options)
    GenServer.stop(pid)
    res
  end

  def search_entries(content_type, query) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.search_entries(pid, content_type, query)
    GenServer.stop(pid)
    res
  end

  @doc """
  Entry calls
  -------------

  These calls deal with a single entry and will always return a map.
  """
  def get_entry(id) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.get_entry(pid, id)
    GenServer.stop(pid)
    res
  end

  def get_entry_prev(id) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.get_entry_prev(pid, id)
    GenServer.stop(pid)
    res
  end

  def update_entry(entry) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.update_entry(pid, entry)
    GenServer.stop(pid)
    res
  end

  def publish_entry(id) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.publish_entry(pid, id)
    GenServer.stop(pid)
    res
  end

  def unpublish_entry(id) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.unpublish_entry(pid, id)
    GenServer.stop(pid)
    res
  end

  def delete_entry(id) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.delete_entry(pid, id)
    GenServer.stop(pid)
    res
  end

  def search_entry(content_type, field, value) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.search_entry(pid, content_type, field, value)
    GenServer.stop(pid)
    res
  end

  def search_entry_prev(content_type, field, value) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.search_entry_prev(pid, content_type, field, value)
    GenServer.stop(pid)
    res
  end

  @doc """
  Asset calls
  -------------

  These calls deal with a single asset and will always return a map.
  """
  def get_asset(id) do
    {:ok, pid} = GenServer.start_link(Excontentful.Client, [])
    res = Excontentful.Client.get_asset(pid, id)
    GenServer.stop(pid)
    res
  end


end
