require "date"
require "logger"

require "pry"

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

namespace :zenweb do
  require "zenweb/tasks"

  Zenweb::Site.text_files << "json"
end

require "crosswords"

include KejadlenDev
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

namespace :sync do
  desc "Sync crosswords"
  task :crosswords, [:start_date] do |t, args|
    nyt_s = ENV.fetch("NYT_S")

    nyt = Crosswords::NYT.new(nyt_s)
    store = Crosswords::Store.new("var/crosswords")

    args.with_defaults(start_date: store.last_date&.to_s || "2014-05-18")
    start_date = Date.parse(args.start_date)
    (start_date..Date.today).each do |date|
      logger.info "Fetching #{date}"
      store[date] = nyt.fetch(date)
    end

    Rake::Task["projects/crosswords/crosswords.json"].invoke
  end

  namespace :crosswords do
    desc "Perform a full re-sync of crosswords"
    task :full do
      Rake::Task["sync:crosswords"].invoke("2014-05-18")
    end

    file "projects/crosswords/crosswords.json" => FileList["var/crosswords/*.json"] do |t|
      data = t.prerequisites
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

      File.write(t.name, JSON.dump(data))
    end
  end
end

task default: "zenweb:generate"
