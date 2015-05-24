require 'singleton'
require 'nokogiri'
require 'yaml'


class Chanel
  include Singleton

  def initialize

    @root = Rails.root.to_s
    @config = YAML.load_file("#{@root}/config/feed.yml")[ENV['RAILS_ENV'] || 'development']
    @feeds = @config['feeds']

    @feeds.each do |key, item|
      item['file'] = @root + @config['path'] + item['fileName']
      unless File.file? item['file']
        new_rss item
      end
      item.delete 'description'
      item.delete 'title'
      item.delete 'ttl'
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

    entity = Nokogiri::XML::Builder.new do |rss|
      rss.item do
        rss.title entity['title']
        rss.description entity['description']
        rss.link "#{feed['host']}#{feed['relativePath']}#{entity['id']}"
        rss.pubDate Time.now.to_s
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

  def new_rss (rss_config)

    builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |rss|
      rss.rss(:version => '2.0') do
        rss.channel do
          rss.title rss_config['title']
          rss.description rss_config['description']
          rss.link rss_config['host']
          rss.ttl rss_config['ttl']
        end
      end
    end

    File.open(rss_config['file'], 'w') do |f|
      f.write builder.to_xml
    end

  end

end
