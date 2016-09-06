defmodule ShoppingList do
  def start_link do
<<<<<<< HEAD
    Task.start_link(fn -> loop(%{}) end)
  end

  def loop(map) do
    receive do
      {:get, caller, msg, listener} ->
        send listener, {:list, caller, msg, map}
        loop(map)
      {:add, value} ->
        keys = Map.keys(map)
        int = length(keys) + 1
        next = Integer.to_string(int)
        map = Map.put(map, String.to_atom(next), value)
        loop(map)
      {:reset} ->
        loop(Map)
    end
  end
end
