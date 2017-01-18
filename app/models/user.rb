class User < ActiveRecord::Base
  attr_accessor :oauth_account

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  # validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  enum u_type: [:volunteer, :admin, :donner]

  validates :mobile_number, :presence => {:message => 'Please enter valid phone number!'},
                     :numericality => true,
                     :uniqueness => true,
                     :length => { :minimum => 10, :maximum => 15 }, if: Proc.new{|user| !user.oauth_account.present?}

  has_many :donations, dependent: :destroy
  has_many :cases, dependent: :destroy
  has_many :schedules, dependent: :destroy

  scope :volunteers, -> {where(u_type: 0)}

  def get_amount_of_donations_used
    donation_ids = self.donations.pluck(:id)
    donated_amount_hash_objs = PublicActivity::Activity.order("created_at desc").where(key: "donation.amount_allocated").where(owner_id: donation_ids).pluck(:parameters)
    total_donated_amount  = 0
    donated_amount_hash_objs.each do |obj|
      puts obj
      total_donated_amount = total_donated_amount + obj[:amount].to_i
    end

    total_donated_amount
  end

  def self.find_for_oauth(auth, signed_in_resource = nil, user_type = 'volunteer')

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user
    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      image_url = auth.info.image
      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email,
          u_type: 0,
          image_url: image_url,
          password: Devise.friendly_token[0,20],
          oauth_account: true
        )
        user.skip_confirmation!

        user.save!
      end
    else
      if user.u_type != user_type && !user.admin?
        user.u_type = user_type
        user.save
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email
  end
end
