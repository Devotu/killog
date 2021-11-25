defmodule Killog.Event do
  defstruct id: "", keys: [], data: %{}, time: 0

  alias Killog.Id
  alias Killog.Event
  alias Killog.Time

  def new(data, keys) when is_list(keys) and is_map(data) do
    %Event{id: Id.guid(), keys: keys, data: data, time: Time.timestamp()}
  end
end
