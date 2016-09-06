defmodule ShoppingList do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  def loop(map) do
    receive do
      {:get, caller, msg, listener} ->
        send listener, {:list, caller, msg, map}
        loop(map)
      {:ready, caller, msg, listener} ->
        IO.puts "READY"
        send listener, {:send, caller, msg, map}
        map = reset_map
        loop(map)
      {:add, value} ->
        keys = Map.keys(map)
        int = length(keys) + 1
        next = Integer.to_string(int)
        map = Map.put(map, String.to_atom(next), value)
        loop(map)
      {:reset} ->
        map = Map.drop(map, Map.keys(map))
        loop(map)
    end
  end

  defp reset_map do
    %{}
  end

  def list_msg(vals) do
    if length(vals) == 0 do
      """
      Lista pusta, dodaj cos kumplu :hankey:
      """
    else
      """
      LISTA:
      ```
      #{Enum.join(vals, "\n")}
      ```
      """
    end
  end

  def ready_msg(vals) do
    if length(vals) > 0 do
      """
      Hej Lenka, lista zakupkow:
      ```
      #{Enum.join(vals, "\n")}
      ```
      dzięki za ogarnięcie, t-001 out :kiss:
      """
    end
  end
end
