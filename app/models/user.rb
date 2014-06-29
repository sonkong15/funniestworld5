class User < ActiveRecord::Base
  attr_accessible :name, :email, :bio, :password, :password_confirmation, :facebook_link,
	:website_link,:avatar, :admin, :facebook_uid, :image_url, :twitter_uid, :user_token, :expires_at, :crypted_password, :password_salt, :persistence_token, :facebook_url, :location,
	:last_name
  has_many :videos
	has_many :uploads
	has_many :articles 
  has_many :events
  has_one :subscription
  	acts_as_tagger
  	acts_as_taggable_on :uploads, :articles
  acts_as_voter

	

	acts_as_authentic do |c|
    c.act_like_restful_authentication = true
	end
    has_attached_file :avatar, :styles =>{ :small => "150x150>"},
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml",
    :path => ":id/:style.:extension",
    :hash_secret => ''

	before_save { |user| user.email = email.downcase }

	validates :name, presence: true, length: { maximum: 25 }
	

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates_presence_of(:email)
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}
	validates :password, presence: true, length: { minimum: 6 }, :on => :create
	validates :password_confirmation, presence: true, :on => :create
	validates :bio, length: {maximum: 1000}
	extend FriendlyId
		friendly_id :name

	def self.find_or_create_from_oauth(auth_hash)
	    provider = auth_hash["provider"]
	    uid = auth_hash["uid"]
		case provider
	      when 'facebook'
	        if user = self.find_by_email(auth_hash["info"]["email"])
	          user.update_user_from_facebook(auth_hash)
	          return user
	        elsif user = self.find_by_facebook_uid(uid)
	          return user
	        else
	          return self.create_user_from_facebook(auth_hash)
	        end
	      when 'twitter'
	        if user = self.find_by_twitter_uid(uid)
	          return user
	        else
	          return self.create_user_from_twitter(auth_hash)
	        end
		end
  	end
  
  def self.create_user_from_twitter(auth_hash)
    self.create({
      :twitter_uid => auth_hash["uid"],
      :name => auth_hash["info"]["name"],
      :image_url => auth_hash["info"]["image"],
      :crypted_password => "twitter",
      :password_salt => "twitter",
      :persistence_token => "twitter"
    })
    
  end
  
  def self.create_user_from_facebook(auth_hash)
    self.create({
      :facebook_uid => auth_hash["uid"],
      :name => auth_hash["info"]["name"],
      :image_url => auth_hash["info"]["image"],
      :email => auth_hash["info"]["email"],
      :last_name => auth_hash["info"]["last_name"],
      :facebook_url => auth_hash["info"]["urls"]["Facebook"],
      :location => auth_hash["info"]["location"],
      :crypted_password => "facebook",
      :password_salt => "facebook",
      #:user_token => auth_hash['credentials']['token'],
      #:expires_at => auth_hash['credentials']['expires_at'],
      :persistence_token => "facebook"
      
    })
  end
  
  def image
    :image_url || "http://placehold.it/48x48"
  end
  
  def password_required?
    facebook_uid.blank? && twitter_uid.blank?
  end
  
  def email_available?
    twitter_uid.blank?
  end
  
  def update_user_from_facebook(auth_hash)
    self.update_attributes({
      :facebook_uid => auth_hash["uid"],
      :image_url => auth_hash["info"]["image"],

      #:user_token => auth['credentials']['token'],
      #:expires_at => auth_hash['credentials']['expires_at']
    })
  end
end
