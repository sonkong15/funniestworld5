class Categorization < ActiveRecord::Base
  attr_accessible :upload_id, :category_id
	belongs_to :upload
	belongs_to :category
end
