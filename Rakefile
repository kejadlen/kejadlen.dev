require "rake/clean"

class Config
  attr_reader *%i[ src out exts ]

  def initialize(src:, out:, exts:)
    @src, @out, @exts = src, out, exts.transform_keys(&:to_s)
  end
end

config = Config.new(
  src: "src",
  out: "out",
  exts: {
    md: ->(content) {
      require "kramdown"
      require "kramdown-parser-gfm"
      Kramdown::Document.new(content, input: "GFM").to_html
    }
  }
)

include FileUtils::Verbose

directory config.out
CLEAN.include(config.out)
task default: config.out

inputs = FileList["#{config.src}/**/*"]
  .include("#{config.src}/**/.*") # include dotfiles

inputs.each do |input|
  segments = input.split(?.)
  exts = []
  while config.exts.keys.include?(segments.last)
    exts << segments.pop
  end

  output = segments.join(?.).sub(/^#{config.src}/, config.out)
  file output => input do
    content = File.read(input)
    exts.map {|ext| config.exts.fetch(ext) }.each do |ext|
      content = ext.(content)
    end
    File.write(output, content)
  end
  CLOBBER.include(output)
  task default: output
end

#
# Meta
#

desc "Serve"
task :serve do
  require "rerun"
  require "webrick"

  Thread.new do
    server = WEBrick::HTTPServer.new(Port: 8000, DocumentRoot: config.out)
    trap "INT" do
      server.shutdown
    end
    server.start
  end

  options = Rerun::Options.parse(args: %w[ --pattern {Gemfile,Gemfile.lock,Rakefile,src/**/*} --exit rake ])
  cmd = options.delete(:cmd)
  runner = Thread.new do
    Rerun::Runner.keep_running(cmd, options)
  end

  system "open http://localhost:8000"

  runner.join
end

desc "Push"
task :push do
  sh "git subtree push --prefix=#{config.out} gh-pages"
end

desc "Setup"
task :setup do
  sh "git remote add --track gh-pages gh-pages git@github.com:kejadlen/kejadlen.dev.git" unless system("git remote show gh-pages")
  sh "git subtree add --prefix=#{config.out} --squash gh-pages gh-pages"
end
