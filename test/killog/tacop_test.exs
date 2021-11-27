defmodule Killog.TacopTest do
  use ExUnit.Case

  alias Killog.Modules.Tacop

  test "select archetype" do
    assert {:seek, "Seek and Destroy"} == Tacop.select_archetype("seek")
  end
end
