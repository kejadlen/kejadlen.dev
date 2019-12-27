require "date"
require "open-uri"

module KejadlenDev
  module Crosswords
    class Store
      def initialize(base_dir)
        @base_dir = base_dir
      end

      # Super inefficient, but whatever...
      def []=(date, day_data)
        path = date.strftime("#@base_dir/%Y-%m.json")
        month_data = File.exist?(path) ? JSON.parse(File.read(path)) : {}
        month_data[date.to_s] = day_data
        File.write(path, JSON.dump(month_data))
      end

      def last_date
        path = Dir["#@base_dir/*.json"].sort.last
        return nil if path.nil?

        JSON.parse(File.read(path)).keys.map {|k| Date.parse(k) }.sort.last
      end
    end

    class NYT
      API = "https://nyt-games-prd.appspot.com/svc/crosswords"

      def initialize(nyt_s)
        @nyt_s = nyt_s
        @puzzles = {}
      end

      def fetch(date)
        id = puzzle_id(date)
        url = "#{API}/v6/game/#{id}.json"
        JSON.parse(URI.open(url, "nyt-s" => @nyt_s).read)
      end

      private

      def puzzle_id(date)
        return @puzzles.fetch(date).fetch("puzzle_id") if @puzzles.has_key?(date)

        last_date = @puzzles.keys.sort.last || date - 1
        date_start = last_date + 1
        date_end = date_start >> 3 # 3 months

        url = "#{API}/v3/55348624/puzzles.json?date_start=#{date_start}&date_end=#{date_end}"
        json = JSON.parse(URI.open(url, "nyt-s" => @nyt_s).read)
        results = json.fetch("results")

        @puzzles.merge!(results.map {|result|
          [Date.parse(result.fetch("print_date")), result]
        }.to_h)

        @puzzles.fetch(date).fetch("puzzle_id")
      end
    end
  end
end
