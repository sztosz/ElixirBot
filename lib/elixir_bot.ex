defmodule ElixirBot do
  use Slacker
  use Slacker.Matcher

  match ~r/.*shots fired.*/, :hate_on
  match ~r/tell which language is the best/, :best_lang
  match ~r/.*najlepszy jezyk.*/, :best_lang
  match ~r/.*dowcip.*/, :joke
  match ~r/mow do tostera/, :gobot
  match ~r/.*please.*/, :plz
  match ~r/dodaj: (w+)/, :add_list
  match ~r/.*pokaz liste.*/, :show_list
  match ~r/.*resetuj liste.*/, :reset_list

  def start(_type, _args) do
    {:ok, tars} = ElixirBot.start_link("token")
    {:ok, pid}  = ShoppingList.start_link
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

  def gobot(tars, msg) do
    reply = "@gobot DUPA"
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
