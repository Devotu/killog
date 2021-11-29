defmodule Killog.UtilTest do
  use ExUnit.Case

  alias Killog.Util

  test "input to numbers" do
    input = %{"a" => "2", "s" => 4, "d" => "test", q: [1,2,4]}
    expected = %{"a" => 2, "s" => 4, "d" => "test", q: [1,2,4]}

    assert expected == Util.value_inputs_to_numbers input
  end

  test "map include keys" do
    input = %{"a" => "2", "b" => 4, "c" => "test"}

    assert true == Util.inluding_keys?(input, ["a", "b", "c"])
    assert true == Util.inluding_keys?(input, ["a", "c"])
    assert false == Util.inluding_keys?(input, ["a", "b", "c", "d"])
  end

  test "validate number" do
    input = %{"a" => "2", "b" => 4, c: 8}

    assert input == Util.validate(input, "b", :number)
    assert input == Util.validate(input, :c, :number)
    assert {:error, "input a not a number"} == Util.validate(input, "a", :number)
    assert {:error, "key d not found"} == Util.validate(input, "d", :number)
  end

  test "validate list of strings" do
    input = %{"a" => ["failure", 2], "b" => ["item", "thing"], c: 8}

    assert input == Util.validate(input, "b", [:list, :string])
    assert input == Util.validate(input, :c, :number)
    assert {:error, "key d not found"} == Util.validate(input, "d", [:list, :string])
    assert {:error, "input a contains other than string"} == Util.validate(input, "a", [:list, :string])
  end
end
