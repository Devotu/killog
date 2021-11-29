defmodule Killog.FactionTest do
  use ExUnit.Case

  alias Killog.Modules.Faction

  test "select faction" do
    faction = Faction.select("chaos")
    assert :chaos == faction.id
    assert "Chaos Marines" == faction.name
  end
end
