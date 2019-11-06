require "date"

require "pry"

namespace :zenweb do
  require "zenweb/tasks"
end

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "crosswords"

include KejadlenDev

namespace :sync do
  namespace :crosswords do
    # desc "update from given date or last fetched crossword YAML"
    # task :update, [:from] do |_, args|
    #   # Rake::Task["projects/crosswords/crosswords.json"].invoke
    # end

    # desc "Perform a full re-sync of crossword data"
    # task :full do
    #   Rake::Task["sync:crosswords:update"].invoke(Date.parse("2014-05-18"))
    # end

    file "projects/crosswords/crosswords.json" => FileList["var/crosswords/*.json"] do |t|
      t.prerequisites
        .map {|path| JSON.parse(File.read(path)) }
        .inject {|h, month_data| h.merge(month_data) }
        .map {|date, data|
          {
            date: date,
            revealedCount: data.fetch("board", {}).fetch("cells", []).count {|cell| cell.has_key?("revealed") },
            secondsSpentSolving: data.fetch("calcs", {}).fetch("secondsSpentSolving", nil),
            solved: data.fetch("calcs", {}).fetch("solved", false),
          }
        }
        # data = Dir["#{File.dirname(page.path)}/*.yml"]
        #   .map {|path| YAML.load_file(path) }
        #   .inject {|h, month_data| h.merge(month_data) }
        #   .map {|date, data|
        #     {
        #       date: date,
        #       revealedCount: data.fetch("board", {}).fetch("cells", []).count {|cell| cell.has_key?("revealed") },
        #       secondsSpentSolving: data.fetch("calcs", {}).fetch("secondsSpentSolving", nil),
        #       solved: data.fetch("calcs", {}).fetch("solved", false),
        #     }
        #   }
    end
  end

  desc "Sync nyt crosswords"
  task :crosswords do |t|
    nyt_s = ENV.fetch("NYT_S")

    nyt = Crosswords::NYT.new(nyt_s)
    store = Crosswords::Store.new("var/crosswords")

    start_date = store.last_date || Date.parse("2014-05-18")
    (start_date..Date.today).each do |date|
      store[date] = nyt.fetch(date)
    end

    Rake::Task["projects/crosswords/crosswords.json"].invoke
  end
end

task default: "zenweb:generate"
