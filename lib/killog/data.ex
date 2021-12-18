defmodule Killog.Data do
  @moduledoc """
  A thin layer to enforce only events in log
  """

  alias Killog.Event

  @id_input "input"

  def log_external_input(%Event{} = event) do
    Trail.store(@id_input, %{}, event)
  end

  def save_state_with_log(id, state, %Event{} = event) when is_bitstring(id) do
    Trail.store(id, state, event)
  end

  def read_log_by_id(id) when is_bitstring(id) do
    Trail.trace(id)
  end

  def recall_state(ids) when is_list(ids) do
    ids
    |> Enum.map(&recall_state/1)
  end
  def recall_state(id) when is_bitstring(id) do
    Trail.recall(id)
  end

  def list_ids(module) when is_atom(module) do
    module
    |> to_namespace()
    |> Trail.list_contains()
  end

  defp to_namespace(module) when is_atom(module) do
    module
    |> Atom.to_string()
    |> String.trim_leading(":")
  end
end
