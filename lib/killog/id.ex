defmodule Killog.Id do
  def hrid(base) do
    base
    |> String.replace(" ", "_")
    |> String.downcase()
  end

  def guid() do
    [
      "cat",
      "hat",
      "cow",
      "sit",
      "rug",
      "hug",
      "bot",
      "pot",
      "bat",
      "fat",
      "car",
      "far",
      "bar",
      "foo",
      "how",
      "jar",
      "par",
      "sub",
      "hub",
      "cub",
      "hop",
      "tap",
      "fit",
      "hit",
      "big",
      "rot",
      "wit",
      "met",
      "pal",
      "lap",
      "inn",
      "cap",
      "run",
      "bun",
      "ill",
      "gap",
      "kit",
      "gin"
    ]
    |> Enum.take_random(2)
    |> Enum.concat([Enum.random(100..999) |> Integer.to_string()])
    |> Enum.concat([Enum.random(10..99) |> Integer.to_string()])
    |> Enum.join("_")
  end
end
