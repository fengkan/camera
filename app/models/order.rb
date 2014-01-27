class Order < ActiveRecord::Base
	belongs_to :user
	belongs_to :shipment
	has_many :order_histories
end
