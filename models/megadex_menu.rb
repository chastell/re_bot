require 'uri'

class MegadexMenu
  DAYS = {1 => 'pon', 2 => 'wt', 3 => 'sr', 4 => 'czw', 5 => 'pi'}
  DAYS_PREFIXES = %w{pon wt sr czw pi}

  MEAL_TYPES = {
    "spec" => "danie specjalne",
    "wege" => "danie wegetariańskie"
  }

  MEGADEX_URL = URI('http://www.galeriasmaku.com.pl/zoliborz/admin/get.php')

  def initialize
    megadex_response = NetConnector.get_data(MEGADEX_URL)
    @menu = prepare_hash(megadex_response)
    @menu.delete("tydzien")
  end

  def for_day(day=nil)
    day = DAYS[day]
    menu = get_menu[day].map {|type, meal| "#{type}: #{meal}" }.join("\n")
    JSON({text: menu})
  end

  private

  def prepare_hash(h)
    Hash[h.split('&').map{ |s| s.split('=')}]
  end

  def get_menu
    Hash[week_menu.compact]
  end

  def week_menu
    @menu.group_by { |k, _| k.split("_").first }.map do |day, daily_menu|
      next unless DAYS_PREFIXES.include?(day)
      day_menu = extract_day_menu(daily_menu)
      [day, day_menu]
    end
  end

  def extract_day_menu(daily_menu)
    daily_menu.map do |key, meal|
      meal_type = key.split("_")[1..-1].join(" ")
      meal_type = MEAL_TYPES[meal_type] || meal_type
      [meal_type, meal]
    end
  end
end
