class Item < ActiveRecord::Base
  after_save :update_feed

  private

  def update_feed
    news_feed = Chanel.new('testhost.ru', 'items', 'new items feed')
    news_feed.update_feed(self)
  end

end
