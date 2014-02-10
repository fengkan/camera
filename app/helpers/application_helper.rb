#encoding: utf-8

module ApplicationHelper
	def render_title
	  return @title if defined?(@title)
	end
	
	def beautify_time(t)
		t.strftime("%Y年%m月%d日 %H:%M")
	end
end
