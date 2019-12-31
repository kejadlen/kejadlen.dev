require "date"
require "logger"

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

require "pry"

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
module KejadlenDev; end
include KejadlenDev

namespace :zenweb do
  require "zenweb/tasks"

  Zenweb::Site.text_files << "json"
end
task default: "zenweb:generate"

task :extra_wirings do
  site = $website
  page = site.pages

  page["blog/index.html.erb"].depends_on site.categories.blog
end

desc "Run and reload the generated site"
task :run do
  require "rerun"
  require "webrick"

  Thread.new do
    server = WEBrick::HTTPServer.new(Port: 8000, DocumentRoot: ".site")
    trap "INT" do
      server.shutdown
    end
    server.start
  end

  options = Rerun::Options.parse(args: %w[ rake zenweb:generate --exit ])
  cmd = options.delete(:cmd)
  runner = Thread.new do
    Rerun::Runner.keep_running(cmd, options)
  end

  system "open http://localhost:8000"

  runner.join
end

desc "Push"
task :push do
  sh "git subtree push --prefix=.site gh-pages"
end

require "crosswords"

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

    crossword_jsons = FileList["var/crosswords/*.json"]
    file "projects/crosswords/crosswords.json" => crossword_jsons do |t|
      data = crossword_jsons
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

desc "Setup"
task :setup do
  sh "git remote add --track gh-pages gh-pages git@github.com:kejadlen/kejadlen.dev.git"
  sh "git subtree add --prefix .site --squash gh-pages gh-pages"
end
