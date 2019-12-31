---
title: Twitter stats using Ruby
...

I saw [Damon Cortesi’s Twitter Stats script](http://dcortesi.com/2007/12/27/twitter-stats/) last night, and decided to make a Ruby version. This was before he released his code, so it’s reverse-engineered rather than ported. I’ll take a look later tonight to see how much the logic differs.

Edit: This code is rather inelegant, and I’ve replaced the clunky CSV files with an Sqlite3 database. You can find the [new and improved scripts here](http://github.com/kejadlen/twitter_stats/tree/master). The following should still work, and I’m leaving it here for posterity’s sake.

First up, I wrote a quick Tweet class to actually get all of my tweets.

```ruby
require 'hpricot'
require 'open-uri'

class Tweet
  def initialize(user)
    @user_url = "http://twitter.com/#{user}"

    @doc = Hpricot(open(@user_url))
    @page = 1

    @tweets = [current_tweet]
    @tweets += page_to_tweets
  end

  def current_tweet
    tweet,time = @doc/'div.desc'/'p'
    tweet = tweet.inner_html
    time = DateTime.parse(time.at('abbr')['title'])

    [tweet, time]
  end

  def page_to_tweets
    (@doc/'div.tab'/'tr.hentry').map do |tweet|
      tweet,time = tweet/'span'
      tweet = tweet.inner_html.gsub(/^\s*(.*)\s*$/, '\1')
      time = DateTime.parse(time.at('abbr')['title'])

      [tweet, time]
    end
  end

  def older?
    (@doc/'div.tab'/'div.pagination'/'a').last.inner_text =~ /Older/
  end

  def succ
    if @tweets.empty?
      return nil unless older?

      @page += 1
      @doc = Hpricot(open("#{@user_url}?page=#{@page}"))
      @tweets = page_to_tweets
    end

    @tweets.shift
  end
end
```

Next, a quick script to download the tweets into a CSV file. This is actually a bit over-engineered, as it’ll only download tweets that have not been previously downloaded. Note that this takes the username as a command line argument.

```ruby
require 'fastercsv'
require 'tweet'

base_path = File.dirname(__FILE__)

csv_files = Dir["#{base_path}/*.csv"].sort_by do |filename|
  DateTime.parse(File.basename(filename, '.csv'))
end

last_update = DateTime.parse(File.basename(csv_files.last, '.csv')) unless csv_files.empty?

tweets = Tweet.new(ARGV.shift)
current_update_time = tweets.current_tweet.last

if last_update.nil? or current_update_time > last_update
  FasterCSV.open(File.join(base_path, "#{current_update_time.to_s}.csv"), 'w') do |csv|
    while t = tweets.succ
      tweet,time = t

      break if last_update and time <= last_update

      csv << [tweet, time.to_s]
    end
  end
end
```

And last, creating the graphs of the statistics from the CSV files.

```ruby
require 'fastercsv'
require 'gchart'
require 'tweet'

base_path = File.dirname(__FILE__)
year = 2007

month_data = Array.new(12, 0)
hour_data = Array.new(24, 0)
reply_data = Hash.new(0)

Dir["#{base_path}/*.csv"].each do |filename|
  FasterCSV.foreach(filename) do |row|
    tweet = row.first
    time = DateTime.parse(row.last)

    month_data[time.month - 1] += 1 if time.year == year
    hour_data[(time.hour-8)%24] += 1 if time.year == year
    reply_data[$1] += 1 if tweet =~ /@<a href="\/([^"]+)">\1<\/a>/ and time.year == year
  end
end

puts GChart.line(
  :title => 'Tweets per Hour',
  :data => hour_data,
  :width => 400,
  :height => 300,
  :extras => { 'chxt' => 'x,y', 'chxl' => "0:|#{(0..23).to_a.join('|')}|1:|#{hour_data.min}|#{hour_data.max}" }
).to_url

puts GChart.bar(
  :title => 'Tweets per Month',
  :data => month_data,
  :width => 400,
  :height => 300,
  :extras => { 'chxt' => 'x,y', 'chxl' => "0:|#{Date::ABBR_MONTHNAMES.compact.join('|')}|1:|#{month_data.min}|#{month_data.max}" },
      :orientation => :vertical
    ).to_url
```

## Output

[tweets/hour](http://chart.apis.google.com/chart?chxt=x,y&chxl=0:%7C0%7C1%7C2%7C3%7C4%7C5%7C6%7C7%7C8%7C9%7C10%7C11%7C12%7C13%7C14%7C15%7C16%7C17%7C18%7C19%7C20%7C21%7C22%7C23%7C1:%7C1%7C40&chs=400x300&cht=lc&chtt=Tweets+per+Hour&chd=e:LNDNGaDNBmDNRmpm-Z..7MgAgAkzzMuZeZ):
{% include img name="tweets-per-hour.png" alt="Tweets per hour" %}

[tweets/month](http://chart.apis.google.com/chart?chxt=x,y&chxl=0:%7CJan%7CFeb%7CMar%7CApr%7CMay%7CJun%7CJul%7CAug%7CSep%7COct%7CNov%7CDec%7C1:%7C0%7C148&chs=400x300&cht=bvs&chtt=Tweets+per+Month&chd=e:AcAAA3AAAAAAAAAAopyl4N..):
{% include img name="tweets-per-month.png" alt="Tweets per month" %}
