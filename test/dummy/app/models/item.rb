class Item < ActiveRecord::Base
  after_save :update_feed

  private

  def update_feed
    Feed.update_stream('items', self)
  end

end
