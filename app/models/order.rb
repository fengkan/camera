class Order < ActiveRecord::Base
	belongs_to :user
	has_one :shipment
	has_many :order_histories
end
