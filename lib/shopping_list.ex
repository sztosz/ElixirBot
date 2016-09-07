defmodule ShoppingList do
  @moduledoc false

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def update(key, value) do
    Agent.update(__MODULE__, &update(&1, key, value))
  end

  def show do
    Agent.get(__MODULE__, &show(&1))
  end

  def reset do
    Agent.update(__MODULE__, fn _ -> %{} end )
  end

  def list_msg do
    content = show

    if String.length(content) == 0 do
      "Lista pusta, dodaj cos kumplu :hankey:"
    else
      """
      LISTA:
      ```#{content}```
      """
    end
  end

  def ready_msg do
    content = show
    reset

    if String.length(content) > 0 do
      """
      Hej Lenka, lista zakupkow:
      ```#{content}```
      dzięki za ogarnięcie, t-001 out :kiss:
      """
    end
  end

  defp update(map, key, value) do
    cond do
        Map.has_key?(map, key) ->
          %{map | key => value}
        true ->
          Map.put_new(map, key, value)
    end
  end

  defp show(map) do
    map
    |> Map.to_list
    |> Enum.map(&stringify(&1))
    |> Enum.join("\n")
  end

  defp stringify(tuple) do
    tuple
    |> Tuple.to_list
    |> Enum.join(": ")
  end
end
