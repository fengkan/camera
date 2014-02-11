#encoding: utf-8

module ApplicationHelper
	def render_title
	  return @title if defined?(@title)
	end
	
	def beautify_time(t)
		t.strftime("%Y年%m月%d日 %H:%M")
	end

	def random_word(len)
		chars = ['2', '3', '4', '5', '6', '8', '9', '0', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'p', 'q', 'r', 's', 't', 'w', 'x', 'y', 'z']
		str = ""
		1.upto(len) { |i| str << chars[rand(chars.size-1)] }
		return str
	end
	
end
