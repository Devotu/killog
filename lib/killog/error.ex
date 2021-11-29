defmodule Killog.Error do

  def new(msg) do
    {:error, msg}
  end
end
