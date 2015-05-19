require 'rss'
require 'fileutils'

class Chanel
  def initialize (path = nil, host, name)
    folder = ENV['RAILS_ENV'] == 'production' ? 'feed' : 'feed-dev'
    @folder = path || "#{Rails.root}/public/#{folder}/"
    @host = host
    @name = name
    @ext = '.rss'
  end

  def build_feed_file

    path = @folder + @name + @ext

    FileUtils.mkdir(@folder)

    unless File.file? path
      rss = RSS::Maker.make('2.0') do |maker|
        maker.channel.language = 'en'
        maker.channel.author = @host
        maker.channel.updated = Time.now.to_s
        maker.channel.link = "#{@host}/feed/#{@name + @ext}"
        maker.channel.title = 'Example Feed'
        maker.channel.description = 'A longer description of my feed.'
        maker.items.new_item do |item|
          item.link = "http://www.ruby-lang.org/en/news/2010/12/25/ruby-1-9-2-p136-is-released/"
          item.title = "Ruby 1.9.2-p136 is released"
          item.updated = Time.now.to_s
        end
      end

      File.open(path, 'w') do |f|
        f.write rss
      end

    end

  end

  def feed
    puts @folder
  end
end