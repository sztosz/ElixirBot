defmodule ShoppingList do
  def start_link do
    Task.start_link(fn -> loop([]) end)
  end

  def loop(list) do
    receive do
      {:get, key, caller} ->
        send caller, list
        loop(list)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
      {:reset} ->
        loop(Map.put(map, key, value))
    end
  end
end
