class Upload < ActiveRecord::Base
  has_many :categorizations
	has_many :categories, :through => :categorizations
	belongs_to :user
	attr_accessible :title, :picture, :text, :link, :tag_list, :category_ids
	extend FriendlyId
    friendly_id :title, use: :slugged


	has_attached_file :picture, :styles =>{ :thumb => "149x116#", :small => "200x160#", :large => "600x500>"},
	:storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml",
    :path => ":id/:style.:extension",
    :hash_secret => ''
    validates :title, length: {maximum: 25}
	validates :title, presence: true
	validates_attachment_presence :picture, presence: true
	
	validates_attachment_content_type :picture, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']

	validates_attachment_size :picture, :less_than => 4.megabyte
	
	def previous_upload
  self.class.first(:conditions => ["created_at  < ? ", created_at ], :order => "created_at desc")
	end

	def next_upload
  self.class.first(:conditions => ["created_at  > ? ", created_at  ], :order => "created_at asc")
	end
	
end
