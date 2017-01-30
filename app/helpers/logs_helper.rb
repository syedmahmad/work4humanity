module LogsHelper
  def formatted_ammount(amnt)
    number_to_currency(amnt, :unit => "")
  end
end
