include FileUtils::Verbose

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "webbie"

include Webbie

site = Site.new(
  renderers: {
    md: ->(content) {
      require "kramdown"
      require "kramdown-parser-gfm"
      Kramdown::Document.new(content, input: "GFM").to_html
    },
  },
)

site.pages.each do |page|
  dir = File.dirname(page.out)
  directory dir

  task page.out => FileList[*page.deps, dir] do
    File.write(page.out, page.render)
  end
end

task :prune do
  FileList["#{site.out}/**/*", "#{site.out}/**/.*"]
    .exclude(site.deps)
    .select {|f| File.file?(f) } # TODO delete empty directories
    .each do |f|
      rm f
  end
end

task default: FileList[
  *site.deps,
  :prune,
]

#
# Meta
#

desc "Serve"
task :serve do
  require "rerun"
  require "webrick"

  Thread.new do
    server = WEBrick::HTTPServer.new(Port: 8000, DocumentRoot: site.out)
    trap "INT" do
      server.shutdown
    end
    server.start
  end

  options = Rerun::Options.parse(args: %w[ --pattern {Gemfile,Gemfile.lock,Rakefile,lib/**/*,src/**/*} --exit rake ])
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
