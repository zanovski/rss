require 'nokogiri'

class Chanel
  def initialize (host, name, path = nil)
    folder = path || "#{Rails.root}/public/feed/"
    name = ENV['RAILS_ENV'] == 'production' ? name : "#{name}-dev"
    ext = '.rss'
    @host = host
    @path = folder + name + ext
    unless File.file? @path
      new_rss @path
    end
  end

  def update_feed (items)
    puts items
    doc = Nokogiri::XML(File.read(@path))
    exist_url = doc.at_xpath("//rss/channel")
    entity = Nokogiri::XML::Builder.new do |xml|
      xml.item do
        xml.title 'Super news'
        xml.description 'some description'
        xml.link 'link_to_page'
        xml.pubDate Time.now.to_s
      end
    end
    exist_url.add_child entity.doc.root.to_xml
    File.open(@path, 'w') do |f|
      f.write doc
    end
  end

  private

  def new_rss (path)

    builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
      xml.rss(:version => '2.0') do
        xml.channel do
          xml.title 'Test title'
          xml.link @host
          xml.description 'test description'
          xml.pubDate Time.now.to_s
        end
      end
    end

    File.open(path, 'w') do |f|
      f.write builder.to_xml
    end

  end

end
