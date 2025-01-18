defmodule HogeTest do
  use ExUnit.Case
  doctest Hoge

  test "greets the world" do
    assert Hoge.hello() == :world
  end
end
