defmodule Excontentful do
  @moduledoc """
  Excontentful is an easy way to work with contentful in a opnionated way. It
  tries to abstract away API decisions that users may not be interesd in. It
  also tries to establish some common defaults 
  """


  @doc """
  Entries calls
  -------------

  These calls deal with many entries and will always return a list.
  """
  def entries do
    Excontentful.Delivery.Entries.all()
  end

  def entries(content_type) do
    Excontentful.Delivery.Entries.by_content(content_type)
  end

  def search_entries(content_type, query) do
    Excontentful.Delivery.Entries.search(content_type, query)
  end

  @doc """
  Entry calls
  -------------

  These calls deal with a single entry and will always return a map.
  """
  def get_entry(id) do
    Excontentful.Delivery.Entry.get?(id)
  end

  def get_entry_prev(id) do
    Excontentful.Preview.Entry.get?(id)
  end

  def update_entry(entry) do
    Excontentful.Management.Entry.update(entry)
  end

  def publish_entry(id) do
    Excontentful.Management.Entry.publish(id)
  end

  def unpublish_entry(id) do
    Excontentful.Management.Entry.unpublish(id)
  end

  def delete_entry(id) do
    Excontentful.Management.Entry.del(id)
  end

  def search_entry(content_type, field, value) do
    Excontentful.Delivery.Entry.search(content_type, field, value)
  end

  def search_entry_prev(content_type, field, value) do
    Excontentful.Preview.Entry.search(content_type, field, value)
  end

end
