defmodule ShoppingList do
  @moduledoc false

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def update(key, value) do
    Agent.update(__MODULE__, &update(&1, key, value))
  end

  def show do
    Agent.get(__MODULE__, show(map))
  end

  def reset do
    Agent.update(__MODULE__, fn _ -> %{} end )
  end

  defp update(map, key, value) do
    cond Map.has_key?(map, key) do
        true ->
          %{map | key => value}
        false ->
          Map.put_new(map, key, value)
    end
  end

  defp show(map)
    map
    |> Map.to_list
    |> Enum.reduce(stringify)
  end

  defp stringify(acc, elemnet) do
    row = element
      |> Tuple.to_list
      |> Enum.reduce(fn(x, acc) -> "#{acc} #{x}")
    "#{acc}\n#{row}"
  end
end
