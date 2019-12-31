require "rake/clean"

class Config
  attr_reader *%i[ src out layouts exts ]

  def initialize(src: "src", out: "out", layouts: "_layouts", exts: {})
    @src, @out = src, out
    @layouts = [ layouts, File.join(src, layouts) ].find {|d| File.directory?(d) }
    @exts = exts.transform_keys(&:to_s)
  end
end

config = Config.new(
  exts: {
    md: ->(content) {
      require "kramdown"
      require "kramdown-parser-gfm"
      Kramdown::Document.new(content, input: "GFM").to_html
    },
  }
)

include FileUtils::Verbose

directory config.out
CLEAN.include(config.out)
task default: config.out

inputs = FileList["#{config.src}/**/*"]
  .include("#{config.src}/**/.*") # include dotfiles
  .exclude(config.layouts, "#{config.layouts}/**/*")

inputs.each do |input|
  segments = input.split(?.)
  exts = []
  while config.exts.keys.include?(segments.last)
    exts << segments.pop
  end

  output = segments.join(?.).sub(/^#{config.src}/, config.out)
  file output => FileList[input, "#{config.layouts}/default.erb"] do
    content = File.read(input)
    exts.map {|ext| config.exts.fetch(ext) }.each do |ext|
      content = ext.(content)
    end

    %w[ default.erb ].map {|l| File.read(File.join(config.layouts, l)) }.each do |layout|
      require "erb"
      content = ERB.new(layout).result_with_hash(content: content)
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
