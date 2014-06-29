class PagesController < ApplicationController
	def index
		@cat = Category.all
  	@uploads = Upload.order("created_at DESC").limit(2)
  	@uploads2 = Upload.order("created_at DESC").offset(2).limit(6)
		
	end
end
