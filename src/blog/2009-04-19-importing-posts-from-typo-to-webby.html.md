---
title: Importing posts from Typo to Webby
---

In the process of moving this blog from [Typo](http://wiki.github.com/fdv/typo/) to [Webby](http://webby.rubyforge.org/), it quickly became obvious that copying the blog posts over by hand was not an option. Searching on Google led me to a [task for importing the posts using an RSS feed](http://www.locomotivation.com/blog/2008/11/21/migrating-to-webby.html), but since I used an SQLite3 database with Typo, I thought it would be easier to just grab the posts directly from the database file.

The bulk of the changes are in [this changelist on GitHub](http://github.com/kejadlen/the_alpha_newswire/commit/93ad250e9402355de5adcdcad6a36a9586bc0478), but I made a few more modifications to the process that are included in later changelists.

`tasks/blog.rake` differs mainly in that it uses the actual database instead of an RSS feed and has regular expressions to convert my Typo code highlighting to use Webby's `UltraVioletHelper`. The code is also cleaned up a bit, to use Rake arguments instead of passing around the created_at time as an ENV variable and also to avoid copying `Webby::Apps::Main#capture_command_line_args`. Changing the database source is left as an exercise for the reader.

```ruby
desc "Import blog posts"
task :import_posts, :dbfile do |t,args|
  require 'active_record'

  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :dbfile => args.dbfile
  )

  class Content < ActiveRecord::Base; end
  class Page < Content; end
  class Article < Content; end

  Article.find(:all, :conditions => { :published => true }).each do |post|
    published_at = post.published_at

    page = ::Webby::Resources.basename(post.title).to_url
    title = post.title
    dir = "#{Webby.site.blog_dir}/#{published_at.strftime('%Y/%m/%d')}"

    ::Webby.site.args = OpenStruct.new(:raw => [title], :page => page, :title => title, :dir => '')

    year = published_at.strftime('%Y')
    month = published_at.strftime('%m')

    Rake::Task['blog:create_year_index'].execute(Rake::TaskArguments.new([:year], [year]))
    Rake::Task['blog:create_month_index'].execute(Rake::TaskArguments.new([:year, :month], [year, month]))

    page = File.join(dir, File.basename(page))

    # Colons in the title isn't correct YAML
    title = "\"#{title}\"" if title =~ /:/

    body = post.body

    # Convert the Ultraviolet textfilter blocks
    body.gsub!(/<typo:ultraviolet(.*?)>/, '<%% uv\1 do -%>')
    body.gsub!('</typo:ultraviolet>', '<%% end -%>')
    body.gsub!(/<%% uv (.*) do -%>/) do
      s = $1.split(' ').map {|i| i.gsub(/(.*)="(.*)[/) { ](#$1) => '#$2'" }}.join(', ')
      s.sub!('linenumber', 'line_numbers')
      "<%% uv #{s} do -%>"
    end

    # Remove extra carriage returns from the SQLite3 string.
    body.gsub!("\r", '')

    Webby::Builder.create(page,
                          :from => File.join(Webby.site.template_dir, 'blog', 'post.erb'),
                          :locals => {
                             :title => title,
                             :directory => dir,
                             :body => body,
                             :created_at => published_at.to_y })
  end
end
```

You'll have to of course add the `<%= body %>` tag in `post.erb`.

Adding arguments to the year and month indices isn't too complicated. At the same time, I disabled the dirty flag for the indices created by the imported posts, as they don't need to be re-rendered more than once.

```ruby
task :create_year_index, :year do |t,args|
  args.with_defaults(:year => Time.now.strftime('%Y'))
  year = args.year

  # ... snip ...

  Webby::Builder.create(fn, :from => tmpl,
        :locals => {:title => year, :directory => dir, :dirty => (year == Time.now.strftime('%Y'))})
  end
end
```

```ruby
task :create_month_index, :year, :month do |t,args|
  args.with_defaults(:year => Time.now.strftime('%Y'), :month => Time.now.strftime('%m'))
  year = args.year
  month = args.month

  # ... snip ...

  Webby::Builder.create(fn, :from => tmpl,
        :locals => {:title => month, :directory => dir, :dirty => ("#{year}.#{month}" == Time.now.strftime('%Y.%m'))})
  end
end
```

The `month.erb` and `year.erb` templates also need to be changed to support disabling the dirty flag:

```erb
<% uv :lang => 'ruby' do -%>
title:      <%= title %>
created_at: <%= Time.now.to_y %>
filter:     erb
<%= 'dirty:      true' if dirty %>
```

Finally, running `webby blog:import_posts[typo.db]` finishes the import process, populating the `content` directory with all of the Typo posts.

**Edit (2009.04.20):** Although this blog post is still technically correct, it's probably better just to grab the latest versions of my tasks and templates from [my github repo](http://github.com/kejadlen/the_alpha_newswire/tree/master). I've cleaned up the tasks a bit and added arguments to the `blog:post` task to specify the date.
