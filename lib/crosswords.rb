require "date"
require "json"
require "open-uri"

module KejadlenDev
  class Crosswords
    def initialize(nyt_s)
      @nyt_s = nyt_s
      @puzzles = {}
    end

    def [](date)
      puzzle_id = puzzle_id(date)
      url = "https://nyt-games-prd.appspot.com/svc/crosswords/v6/game/#{puzzle_id}.json"
      JSON.parse(open(url, "nyt-s" => @nyt_s).read)
    end

    def puzzle_id(date)
      return @puzzles.fetch(date).fetch("puzzle_id") if @puzzles.has_key?(date)

      last_date = @puzzles.keys.sort.last || date - 1
      date_start = last_date + 1
      date_end = date_start >> 3 # 3 months

      url = "https://nyt-games-prd.appspot.com/svc/crosswords/v3/55348624/puzzles.json?date_start=#{date_start}&date_end=#{date_end}"
      json = JSON.parse(open(url, "nyt-s" => @nyt_s).read)
      results = json.fetch("results")

      @puzzles.merge!(results.map {|result|
        [Date.parse(result.fetch("print_date")), result]
      }.to_h)

      @puzzles.fetch(date).fetch("puzzle_id")
    end
  end
end
