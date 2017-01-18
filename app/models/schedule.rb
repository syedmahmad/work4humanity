class Schedule < ActiveRecord::Base
	belongs_to :user
	default_scope { order(selected_date: :desc) }
end
