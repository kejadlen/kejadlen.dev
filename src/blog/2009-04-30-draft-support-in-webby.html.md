---
title: Draft support in Webby
---

Because I'm a) lazy and b) a huge nerd, I added support for drafts to this blog, which runs on [Webby](http://webby.rubyforge.org/). (**Edit:** But not anymore! It now uses [nanoc](http://nanoc.stoneship.org/).) It's fairly straightforward, requiring two new tasks in `blog.rake` and of course, the `draft.erb` template. As always, the latest code can be found [at my blog's github repo](http://github.com/kejadlen/the_alpha_newswire/tree/master).

In `blog.rake`:

```ruby
desc 'Create a new draft'
task 'draft' do |t|
  page, title, dir = Webby::Builder.new_page_info
  title = Webby.site.args.raw[0] # undo the titlecasing

  raise "Don't specify a directory for a blog post!" unless dir.empty?

  page = File.join(Webby.site.draft_dir, File.basename(page))
  page = Webby::Builder.create(page,
                               :from => File.join(Webby.site.template_dir, 'blog', 'draft.erb'),
                               :locals => {
                                  :title => title,
                                  :directory => Webby.site.draft_dir })
  Webby.exec_editor(page)
end

desc 'Publish a draft'
task 'publish_draft' do |t|
  site = Webby.site
  draft = site.args.raw[0]
  drafts = Dir["#{site.content_dir}/#{site.draft_dir}/*#{draft}*.txt"]

  raise "No drafts matching '#{draft}'" if drafts.empty?

  raise "Found multiple drafts matching '#{draft}': #{drafts.map {|d| File.basename(d) }.join(', ')}" if drafts.size > 1

  # drafts.size == 1
  draft = drafts[0]
  draft = Webby::Resources::Page.new(draft)

  now = Time.now
  year = now.strftime('%Y')
  month = now.strftime('%m')
  day = now.strftime('%d')

  dir = File.join(Webby.site.blog_dir, year, month, day)
  page = File.join(dir, draft.name)

  page = Webby::Builder.create(page,
                               :from => File.join(Webby.site.template_dir, 'blog', 'post.erb'),
                               :locals => {
                                  :title => draft._meta_data['title'],
                                  :directory => dir,
                                  :created_at => now.to_y,
                                  :body => draft._read })
  Logging::Logger['Webby'].info "deleting #{draft.path}"
  FileUtils.rm(draft.path)
end
```

This does require the modifications to the `create_year_index` and `create_month_index` tasks I made, but should be relatively straightforward to port back into the `blog.rake` file included with Webby's blog template.

To use this, I create draft posts using `webby blog:draft "Some draft title"` and when I'm ready to actually post the article, `webby blog:publish_draft title`. (The argument for `publish_draft` is used in a regex to locate the draft to publish.)
