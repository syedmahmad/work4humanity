class LogsController < ApplicationController
  def index
  	@logs = PublicActivity::Activity.order("created_at desc").where(key: 'donation.amount_received')
  end
end
