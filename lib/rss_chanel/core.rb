require 'nokogiri'

class Chanel
  def initialize (host, name, chanel_title)
    folder = "#{Rails.root}/public/feed/"
    name = ENV['RAILS_ENV'] == 'production' ? name : "#{name}-dev"
    ext = '.rss'
    @host = host
    @path = folder + name + ext
    unless File.file? @path
      new_rss @path, chanel_title
    end
  end

  def update_feed (item)
    doc = Nokogiri::XML(File.read(@path))
    exist_chanel = doc.at_xpath("//rss/channel")
    entity = Nokogiri::XML::Builder.new do |xml|
      xml.item do
        xml.title item['title']
        xml.description item['description']
        xml.link "#{@host}/name/#{item['id']}"
        xml.pubDate Time.now.to_s
      end
    end
    exist_chanel.add_child entity.doc.root.to_xml
    File.open(@path, 'w') do |f|
      f.write doc
    end
  end

  private

  def new_rss (path, chanel_title)

    builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
      xml.rss(:version => '2.0') do
        xml.channel do
          xml.title chanel_title
          xml.link @host
          xml.pubDate Time.now.to_s
        end
      end
    end

    File.open(path, 'w') do |f|
      f.write builder.to_xml
    end

  end

end
