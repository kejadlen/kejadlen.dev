require "date"
require "open-uri"
require "yaml"

require "pry"

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "crosswords"

include KejadlenDev

namespace :sync do
  desc "sync nyt crosswords"
  task :crosswords do |t, args|
    nyt_s = ENV.fetch("NYT_S")

    crosswords = Crosswords.new(nyt_s)

    start_month = FileList["var/crosswords/**.yml"].sort.last&.pathmap("%n") || "2014-05"
    date = Date.parse("#{start_month}-01")
    until date > Date.today
      month_data = (date...(date >> 1))
        .select {|date| date <= Date.today }
        .map {|date| [date, crosswords[date]] }
        .to_h
      File.write(date.strftime("var/crosswords/%Y-%m.yml"), YAML.dump(month_data))
      date >>= 1
    end
  end
end

desc "setup a new repo"
task :setup do
  sh "brew install geckodriver"
end

def silence_warnings
  old_stderr = $stderr
  $stderr = StringIO.new
  yield
ensure
  $stderr = old_stderr
end
