defmodule ElixirBot do
  use Slacker
  use Slacker.Matcher

  match ~r/t-001.*shots fired.*/, :hate_on
  match ~r/t-001.*najlepszy jezyk.*/, :best_lang
  match ~r/t-001.*dowcip|smieszkuj.*/, :joke
  match ~r/t-001.*please.*/, :plz
  match ~r/t-001.*dodaj (\w+) (.*)/, :add_list
  match ~r/t-001.*pokaz liste.*/, :show_list
  match ~r/t-001.*resetuj|wyczysc liste.*/, :reset_list
  match ~r/t-001.*pomocy.*/, :help
  match ~r/t-001.*wysylaj|wysyloj|koniec dnia dziecka.*/, :list_ready

  def start(_type, _args) do
    {:ok, listener} = Task.start_link(fn -> loop() end)
    Process.register(listener, :listener)
    {:ok, pid} = ShoppingList.start_link
    Process.register(pid, :shopping)
    {:ok, tars} = ElixirBot.start_link("")
  end

  def add_list(tars, msg, item, quantity) do
    send :shopping, {:add, "#{item}, #{quantity}"}
    say tars, msg["channel"], "#{item} #{quantity} dodane do listy koleszko :ok_hand:"
  end

  def show_list(tars, msg) do
    send :shopping, {:get, tars, msg, :listener}
  end

  def reset_list(tars, msg) do
    send :shopping, {:reset}
    say tars, msg["channel"], "Lista wyczyszczona :chewbacca:"
  end

  def list_ready(tars, msg) do
    send :shopping, {:ready, tars, msg, :listener}
  end

  def loop() do
    receive do
      {:list, caller, msg, map} ->
            say caller, msg["channel"], ShoppingList.list_msg(Map.values(map))
            loop
      {:send, caller, msg, map} ->
        IO.puts "#{ShoppingList.ready_msg(Map.values(map))}"
        say caller, "ID KANALU ROZMOWY Z LENA", ShoppingList.ready_msg(Map.values(map))
        loop
    end
  end

  def help(tars, msg) do
    reply = """
    Co sie dzieje przyjacielu? :smirk: Wpisz moje imie i powiedz co Ci dolega:
    ```dowcip|smieszkuj - powiem dowcip,
    dodaj [przedmiot - 1 wyraz] [ilosc - wiele wyrazow] - dodam do listy,
    pokaz liste - pokaz aktualna liste zakupow,
    resetuj|wyczysc liste - usun liste zakupow,
    wysylaj - wyslij liste do Leny.```
    """
    say tars, msg["channel"], reply
  end

  def hate_on(tars, msg) do
    reply = "HATE ON :fire:"
    say tars, msg["channel"], reply
  end

  def best_lang(tars, msg) do
    reply = "Go :muscle:, FYI elixir has flat ass..."
    say tars, msg["channel"], reply
  end

  def joke(tars, msg) do
    reply = select_joke
    say tars, msg["channel"], reply
  end

  def plz(tars, msg) do
    reply = "give me some sugar babe :suspect:"
    say tars, msg["channel"], reply
  end

  defp select_joke do
    jokes = [
      "Przychodzi elixir do lekarza, a lekarz to tez elixir :troll:",
      "Przychodzi Bartosz do baru, barman pyta sie co podać. Bartosz na to: ELIXIR :sweat_smile:",
      "W restauracji klient woła kelnera. - W moim elixirze pływa mucha! Na co kelner: No to trzbea będzie dopłacić za wkładkę :laughing:",
      "Co wspólnego ma toster atomowy i elixir? Obaj nie widzieli sie w produkcji :laughing:",
      "W jakiej szkole sa puste sale? W elixir-szkole, bo nie wpuszczaja tam zadnych obiektow :troll:",
      "Przychodzi 60 letni chłop do dyrektora elixir-szkoły i pyta się dlaczego ciągle po tylu latach jest w I klasie. - Niestety nie możemy przypisać do pana nowej wartości :troll:"
    ]
    Enum.random(jokes)
  end
end
