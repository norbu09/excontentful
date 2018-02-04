defmodule ExcontentfulTest do
  use ExUnit.Case
  doctest Excontentful

  test "greets the world" do
    assert Excontentful.hello() == :world
  end
end
