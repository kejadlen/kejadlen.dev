desc "Push"
task :push do
  sh "git subtree push --prefix=.site gh-pages"
end

desc "Setup"
task :setup do
  sh "git remote add --track gh-pages gh-pages git@github.com:kejadlen/kejadlen.dev.git"
  sh "git subtree add --prefix .site --squash gh-pages gh-pages"
end
