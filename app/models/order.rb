class Order < ActiveRecord::Base
	belongs_to :user
	belongs_to :shipment
	has_many :order_histories
	has_many :order_items

	before_save :save_history
	#after_create :gen_md5

  def save_history
  	oh = self.order_histories.build(:status => self.status)
  end

  def gen_md5
  	self.md5 = Digest::MD5.hexdigest(self.id)
  end


end
