class LogsController < ApplicationController
  def index
  	@available_balance = get_remaining_balance
  end
end
