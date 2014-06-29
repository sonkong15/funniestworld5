class Category < ActiveRecord::Base
 attr_accessible :name, :title, :description
	 has_many :categorizations
	 has_many :uploads, :through => :categorizations
   scope :home_random, order("RANDOM()").limit(11)
   scope :category_show, order("created_at DESC")
   Category.joins(:Uploads)
   extend FriendlyId
    friendly_id :title, use: :slugged

	def self.tokens(query)
    	categories = where("name like ?", "%#{query}%")
    	if categories.empty?
    	  [{id: "<<<#{query}>>>", name: "can\'t make a Category: \"#{query}\""}]
    	else
         categories
    	end
  	end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end
