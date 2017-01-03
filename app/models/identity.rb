class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

  def self.create_with_omniauth( auth )
    identity = Identity.new
    identity[:provider] = auth["provider"]
    identity[:uid] = auth["uid"]
  end
end
