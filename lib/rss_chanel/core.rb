require 'nokogiri'

class Chanel
  def initialize (host, name, path = nil)
    @folder = path || "#{Rails.root}/public/feed/"
    @host = host
    @name = ENV['RAILS_ENV'] == 'production' ? name : "#{name}-dev"
    @ext = '.rss'
  end

  def news_rss

    path = @folder + @name + @ext

    builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
      xml.rss(:version => '2.0') do
        xml.channel do
          xml.title ''
          xml.link ''
          xml.description ''
          xml.pubDate Time.now.to_s
          10.times do
            xml.item do
              xml.title 'Super news'
              xml.description 'some description'
              xml.link 'link_to_page'
              xml.pubDate Time.now.to_s
            end
          end
        end
      end
    end

    File.open(path, 'w') do |f|
      f.write builder.to_xml
    end

  end

  def feed
    puts @folder
  end
end