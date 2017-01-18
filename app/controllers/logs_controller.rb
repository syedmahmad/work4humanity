class LogsController < ApplicationController
  add_breadcrumb "History", :logs_path
  def index
    @Requested_amount = Donation.all.requested
  	@logs = PublicActivity::Activity.order("created_at desc").where(key: 'donation.amount_received')
  end
end
