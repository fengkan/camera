class Shipment < ActiveRecord::Base
	belongs_to :user
	
	def mixed_str
		return (name.blank? ? "" : name) + " " + (phone.blank? ? "" : phone) + " " + (address.blank? ? "" : address)
		
	end
end
