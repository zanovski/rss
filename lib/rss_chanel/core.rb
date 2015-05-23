require 'singleton'
require 'nokogiri'
require 'yaml'


class Chanel
  include Singleton

  def initialize

    @root = Rails.root.to_s
    @config = YAML.load_file("#{@root}/config/feed.yml")[ENV['RAILS_ENV']]
    @feeds = @config['feeds']

    @feeds.each do |key, item|
      item['file'] = @root + @config['path'] + item['fileName']
      unless File.file? item['file']
        new_rss item['file']
      end
    end
  end

  def update_stream (name, entity)

    raise "This feed: #{name} isn't exist" unless @feeds.has_key? name
    feed = @feeds[name]
    feed_length = feed['length'] || 10
    file_path = feed['file']
    file_content = File.read(file_path)
    doc = Nokogiri::XML(file_content)
    exist_chanel = doc.at_xpath("//rss/channel")

    doc.xpath("//item[1]").remove if doc.xpath("//item").length >= feed_length

    entity = Nokogiri::XML::Builder.new do |xml|
      xml.item do
        xml.title entity['title']
        xml.description entity['description']
        xml.link "#{@config['host']}#{feed['relativePath']}#{entity['id']}"
        xml.pubDate Time.now.to_s
      end
    end

    exist_chanel.add_child entity.doc.root.to_xml

    File.open(file_path, 'w') do |f|
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
