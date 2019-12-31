---
title: An unholy union of hated technologies
...

So recently, [I did a thing][gist].

[gist]: https://gist.github.com/kejadlen/67f28ed8f618bb7e60a1c22b2f048007

It all started with a question posed by one of my coworkers:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Dear tech Twitter: anyone have any recommendations for a plain text, human-readable database format? Small amount of data, which I want to be able to read myself.<br><br>So far I&#39;ve found GNU recutils: <a href="https://t.co/sjaDQZcf0W">https://t.co/sjaDQZcf0W</a></p>&mdash; Arthaey Angosii (@arthaey) <a href="https://twitter.com/arthaey/status/980091074398990339?ref_src=twsrc%5Etfw">March 31, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

This seems like a pretty straightforward request, and one that I expected to
have a recommendation for, but nothing came to mind. So naturally, I turned
towards two of my favorite bang-for-your-buck technologies. YAML, for
human-read-and-write-ability and machine-parsability, and ActiveRecord + pry
for querying and data manipulation. Not only that, but I knew that there
already existed a convenient bridge between the two, since [Rails comes with a
way to load YAML fixtures into ActiveRecord][fixtures].

[fixtures]: http://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures

It's been a while since I've done any Rails, but some cursory Googling produced
the necessary code to create an in-memory SQLite database without any Rails:

```ruby
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
```

Some more Googling and source-diving quickly resulted in finding [a
promising-looking method for loading fixtures manually][load-fixtures], so I
created a sample `sites.yml` file based on the fixtures documentation and gave
it a shot:

[load-fixtures]: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/fixtures.rb#L531

```yaml
rubyonrails:
  name: Ruby on Rails
  url: http://www.rubyonrails.org

google:
  name: Google
  url: http://www.google.com
```

```ruby
class Site < ActiveRecord::Base
end

ActiveRecord::FixtureSet.create_fixtures(__dir__, Dir["*.yml"])
```

It was no surprise that this didn't work, but it didn't take long to work
through the error messages to first strip the file names of the `.yml`
extension:

```ruby
ActiveRecord::FixtureSet.create_fixtures(__dir__, Dir["*.yml"].map {|file| File.basename(file, ".yml") })
```

And then, writing a schema so ActiveRecord would know the structure of the
entities:

```ruby
ActiveRecord::Schema.define(version: 1) do
  create_table :sites do |t|
    t.text :name
    t.text :url
  end
end
```

And thus, we arrive at a working MVP of a human-readable, human-writable,
and database-queryable tool:

```sh
❯ be ruby yaml_sql.rb 
-- create_table(:sites)
   -> 0.0143s

From: sqyaml.rb @ line 19 :

    14: end
    15: 
    16: ActiveRecord::FixtureSet.create_fixtures(__dir__, Dir["*.yml"].map {|file| File.basename(file, ".yml") })
    17: 
    18: require "pry"
 => 19: binding.pry

(main)> Site.all
=> [#<Site:0x00007fede4c005d8 id: 350860022, name: "Ruby on Rails", url: "http://www.rubyonrails.org">, #<Site:0x00007fede43661e8 id: 622654802, name: "Google", url: "http://www.google.com">]
(main)> 
```

So, lots of people hate on Ruby, YAML, and ActiveRecord, but being able to
produce this proof of concept in about half an hour is pretty great.
