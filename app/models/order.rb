#encoding: utf-8

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
  
  def readable_status
  	case status
		when 'pending'
			return "等待制作"
		when 'making'
			return "制作中..."
		when 'delivering'
			return "配送中"
		when 'received'
			return "已签收"
		end
	end
    
    def status_class
        case status
            when 'new'
            return 'orderlist-state4'
            when 'pending'
            return 'orderlist-state1'
            when 'making'
            return 'orderlist-state'
            when 'delivering'
            return 'orderlist-state2'
            when 'received'
            return 'orderlist-state3'
        end
    end


end
