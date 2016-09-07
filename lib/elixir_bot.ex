defmodule ElixirBot do
  use Slacker
  use Slacker.Matcher

  match ~r/t-001.*shots fired.*/, :hate_on
  match ~r/t-001.*najlepszy jezyk.*/, :best_lang
  match ~r/t-001.*dowcip|smieszkuj.*/, :joke
  match ~r/t-001.*please.*/, :plz
  match ~r/t-001.*hotswap.*/, :hotswap
  match ~r/.*kawa|:tea:|:coffee:.*/, :kawa
  match ~r/.*papu|jedzenie|:piggy:|#teamroot|moa|pasi|pasibus.*/, :papu

  match ~r/t-001.*dodaj (\w+) (.*)/, :add_to_list
  match ~r/t-001.*pokaz liste.*/, :show_list
  match ~r/t-001.*resetuj|wyczysc liste.*/, :reset_list
  match ~r/t-001.*wysylaj|wysyloj|koniec dnia dziecka.*/, :list_ready

  match ~r/t-001.*pomocy.*/, :help

  def start(_type, _args) do
    ShoppingList.start_link
    ElixirBot.start_link("")
  end

  def add_to_list(slack_bot, msg, item, quantity) do
    ShoppingList.update(item, quantity)
    say slack_bot, msg["channel"], "`#{item} #{quantity}` dodane do listy koleszko :ok_hand:"
  end

  def show_list(slack_bot, msg) do
    say slack_bot, msg["channel"], ShoppingList.list_msg
  end

  def reset_list(slack_bot, msg) do
    ShoppingList.reset
    say slack_bot, msg["channel"], "Lista wyczyszczona :chewbacca:"
  end

  def list_ready(slack_bot, msg) do
    reply = ShoppingList.ready_msg
    case reply do
      nil ->
        say slack_bot, msg["channel"], "Lista pusta, przed spamowaniem zapelnijcie ja pl0x :hankey:"
      _ ->
        say slack_bot, "D28MWA4N7", reply
        say slack_bot, msg["channel"], "Wyslane, dzieki koledzy :ok_hand:"
    end
  end

  def help(slack_bot, msg) do
    reply = """
    Co sie dzieje przyjacielu? :smirk: Wpisz moje imie i powiedz co Ci dolega:
    ```dowcip|smieszkuj - powiem dowcip,
    dodaj [przedmiot - 1 wyraz] [ilosc - wiele wyrazow] - dodam do listy,
    pokaz liste - pokaz aktualna liste zakupow,
    resetuj|wyczysc liste - usun liste zakupow,
    wysylaj - wyslij liste do Leny.```
    """
    say slack_bot, msg["channel"], reply
  end

  def hate_on(slack_bot, msg) do
    reply = "HATE ON :fire:"
    say slack_bot, msg["channel"], reply
  end

  def best_lang(slack_bot, msg) do
    reply = "Go :muscle:, FYI elixir has flat ass..."
    say slack_bot, msg["channel"], reply
  end

  def joke(slack_bot, msg) do
    reply = select_joke
    say slack_bot, msg["channel"], reply
  end

  def plz(slack_bot, msg) do
    reply = "give me some sugar babe :suspect:"
    say slack_bot, msg["channel"], reply
  end

  def kawa(slack_bot, msg) do
    case :rand.uniform(2) do
       1 ->
        reply = select_tea_saying
        say slack_bot, msg["channel"], reply
      _ ->
    end
  end

  def papu(slack_bot, msg) do
    case :rand.uniform(2) do
      2 ->
        reply = select_papu_saying
        say slack_bot, msg["channel"], reply
      _ ->
    end
  end

  def hotswap(slack_bot, msg) do
    reply = "hotswap my ass :gun:"
    say slack_bot, msg["channel"], reply
  end

  defp select_tea_saying do
    sayings = [
      "Kawa jest dla slabych, herbulka ftw :fist:",
      "Gdzie kucharek sześć tam nie ma co pić :tea:",
      "Bartosz nie miel za mocno :smirk:",
      "Mniej picia, wiecej kodu :baby_bottle:",
      "Hint: zagotuj więcej wody :sake:"
    ]
    Enum.random(sayings)
  end

  defp select_papu_saying do
    sayings = [
      "Może root? :troll:",
      "Moa > Pasibus :hamburger:",
      "Kto zjada ostatki ten piękny i gładki :nail_care:",
      "Zwycięzcy jedzą w piekarnii :bread:",
      "Pomyje w ryje :ramen:",
      "Wrapy prosze wsadzać do japy :burrito:"
    ]
    Enum.random(sayings)
  end

  defp select_joke do
    jokes = [
      "Przychodzi elixir do lekarza, a lekarz to tez elixir :troll:",
      "Przychodzi Bartosz do baru, barman pyta sie co podać. Bartosz na to: ELIXIR :sweat_smile:",
      "W restauracji klient woła kelnera. - W moim elixirze pływa mucha! Na co kelner: No to trzbea będzie dopłacić za wkładkę :laughing:",
      "Co wspólnego ma toster atomowy i elixir? Obaj nie widzieli sie w produkcji :laughing:",
      "W jakiej szkole sa puste sale? W elixir-szkole, bo nie wpuszczaja tam zadnych obiektow :troll:",
      "Przychodzi 60 letni chłop do dyrektora elixir-szkoły i pyta się dlaczego ciągle po tylu latach jest w I klasie. - Niestety nie możemy przypisać do pana nowej wartości :troll:",
      "Elixir opowiada dowcip elixirowi: - Puk puk; - Kto tam?; - Nie znaleziono kto/1, czy masz na mysli kto/2 :crab:",
      "Dlaczego profesor Snape byl taki smutny? Bo uczyl ELIXIRow :troll:",
      "Jaki rodzaj orzeszkow najbardziej lubi elixir? MIX :sweat_smile:",
      "Co powiedzial elixir kiedy przyszedl do KFC? Poprosze LangEra :laughing:",
      "Co mowi kon piszacy w elixirze? Nic, konie nie mowia :troll:",
      "Dlaczego elixir jest taki samotny? Bo nie ma zadnych OBIEKTOW zainteresowan :chewbacca:",
      "Jaki jest ulubiony film elixira? A Nightmare on Elm Street :laughing:"
    ]
    Enum.random(jokes)
  end
end
