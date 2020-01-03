---
title: Improved Twitter stats in Ruby
---

The previous method was a bit messy, so I’ve cleaned it up a bit.

[tweets/hour](http://chart.apis.google.com/chart?chxt=x,y&chxl=0:%7C0%7C1%7C2%7C3%7C4%7C5%7C6%7C7%7C8%7C9%7C10%7C11%7C12%7C13%7C14%7C15%7C16%7C17%7C18%7C19%7C20%7C21%7C22%7C23%7C1:%7C1%7C40&chs=400x300&cht=lc&chtt=Tweets+per+Hour&chd=e:LNDNGaDNBmDNRmpm-Z..7MgAgAkzzMuZeZv.eZrM3.-ZeZOZ)
{% include img name="tweets-per-hour.png" alt="Tweets per hour" %}

[tweets/month](http://chart.apis.google.com/chart?chxt=x,y&chxl=0:%7CJan%7CFeb%7CMar%7CApr%7CMay%7CJun%7CJul%7CAug%7CSep%7COct%7CNov%7CDec%7C1:%7C0%7C148&chs=400x300&cht=bvs&chtt=Tweets+per+Month&chd=e:AcAAA3AAAAAAAAAAopyl4N..)
{% include img name="tweets-per-month.png" alt="Tweets per month" %}

[See the code at GitHub here.](http://github.com/kejadlen/twitter_stats/tree/master)

`twitter.rb` now uses an Sqlite3 database to hold the data.

```ruby
require 'active_record'
require 'hpricot'
require 'open-uri'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile => File.join(File.dirname(__FILE__), 'tweets.db')
)

class Tweet < ActiveRecord::Base
  def time
    DateTime.parse(time_before_type_cast)
  end
end

class Twitter
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

    {:tweet => tweet, :time => time}
  end

  def page_to_tweets
    (@doc/'div.tab'/'tr.hentry').map do |tweet|
      tweet,time = tweet/'span'
      tweet = tweet.inner_html.gsub(/^\s*(.*)\s*$/, '\1')
      time = DateTime.parse(time.at('abbr')['title'])

      {:tweet => tweet, :time => time}
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

```ruby
require 'twitter'

last_tweet = Tweet.find(:first, :order => 'time DESC')

tweets = Twitter.new(ARGV[0])

if last_tweet.nil? or tweets.current_tweet[:time] > last_tweet.time
  while tweet = tweets.succ
    break if last_tweet and tweet[:time] <= last_tweet.time

    Tweet.create(tweet)
  end
end
```

```ruby
require 'gchart'
require 'twitter'

    month_data = Array.new(12, 0)
    day_data = Array.new(7, 0)
    hour_data = Array.new(24, 0)
reply_data = Hash.new(0)

    Tweet.find(:all).select {|t| t.time.year == 2007 }.each do |t|
    month_data[t.time.month-1] += 1
    day_data[t.time.wday] += 1
    hour_data[(t.time.hour-8)%24] += 1
    reply_data[$1] += 1 if t[:tweet] =~ /@<a href="\/([^"]+)">\1<\/a>/
    end

def min_max_label(data)
    "|#{data.min}|#{data.max}"
    end

    puts GChart.line(
            :title => 'Tweets per Hour',
            :data => hour_data,
            :width => 400,
            :height => 300,
            :extras => { 'chxt' => 'x,y', 'chxl' => "0:|#{(0..23).to_a.join('|')}|1:#{min_max_label(hour_data)}" }
            ).to_url

    puts GChart.bar(
            :title => 'Tweets per Day',
            :data => day_data,
            :width => 400,
            :height => 300,
            :extras => { 'chxt' => 'x,y', 'chxl' => "0:|#{Date::ABBR_DAYNAMES.compact.join('|')}|1:#{min_max_label(day_data)}" },
            :orientation => :vertical
            ).to_url

    puts GChart.bar(
            :title => 'Tweets per Month',
            :data => month_data,
            :width => 400,
            :height => 300,
            :extras => { 'chxt' => 'x,y', 'chxl' => "0:|#{Date::ABBR_MONTHNAMES.compact.join('|')}|1:#{min_max_label(month_data)}" },
            :orientation => :vertical
            ).to_url

    reply_data = reply_data.sort_by {|_,v| v }.reverse
    reply_data.each {|k,v| puts "#{k}: #{v}" }
    reply_labels = reply_data.map {|k,_| k }
    reply_data = reply_data.map {|_,v| v }
    puts GChart.bar(
            :title => 'Most Replies',
            :data => reply_data,
            :width => 400,
            :height => 300,
            :extras => { 'chxt' => 'x,y', 'chxl' => "0:|#{reply_labels.join('|')}|1:#{min_max_label(reply_data)}" },
            :orientation => :vertical
            ).to_url
```
