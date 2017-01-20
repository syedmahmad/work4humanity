class LogsController < ApplicationController
  def index
    @requested_amount = Donation.all.requested.order(:created_at => "DESC")
  	@logs = PublicActivity::Activity.all.order("created_at desc")
  end
end
