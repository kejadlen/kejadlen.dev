require "rake/clean"

Config = Struct.new(*%i[ src out ], keyword_init: true)

config = Config.new({
  src: "src",
  out: "out",
})

include FileUtils::Verbose

directory config.out
CLEAN.include(config.out)
task default: config.out

site = FileList["#{config.src}/**/*"]
  .map {|input| [input.pathmap("%{#{config.src},#{config.out}}p"), input] }
  .to_h
task default: site.keys

site.each do |output, input|
  file output => input do
    cp input, output
  end
  CLEAN.include(output)
end

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

  options = Rerun::Options.parse(args: %w[ rake --exit ])
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
