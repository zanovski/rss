require 'nokogiri'
require 'yaml'


class Chanel

  def initialize
    @root = Rails.root.to_s
    @config = YAML.load_file("#{@root}/config/feed.yml")[ENV['RAILS_ENV']]

    feeds = @config['feeds']

    feeds.each do |key, item|
      file = @root + @config['path'] + item['fileName']
      unless File.file? file
        new_rss(file)
      end
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

  def self.create_chanel
    raise 'Abstract static method'
  end

  private

  def new_rss (path)

    builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
      xml.rss(:version => '2.0') do
        xml.channel do
          xml.title @config['title']
          xml.link @config['host']
          xml.pubDate Time.now.to_s
        end
      end
    end

    File.open(path, 'w') do |f|
      f.write builder.to_xml
    end

  end

end
