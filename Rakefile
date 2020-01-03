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

  task page.out => FileList[*page.deps, dir, "Gemfile.lock", "Rakefile", "lib/**/*.rb"] do
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
  require "rack"

  static = Rack::Static.new(nil, urls: [""], root: site.out, index: "index.html")
  app = ->(env) {
    req = Rack::Request.new(env)
    file = File.join(site.out, req.path)
    file << ".index.html" if File.directory?(file)
    Rake::Task[file].invoke if Rake::Task.task_defined?(file)

    static.call(env)
  }

  Rack::Server.start(
    app: app,
    Port: 8000,
  )
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
