class Shipment < ActiveRecord::Base
	belongs_to :user
	
	def mixed_str
		return (name.blank? ? "" : name) + " " + (address.blank? ? "" : address) + " " + (phone.blank? ? "" : phone)
		
	end
end
