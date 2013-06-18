# encoding: utf-8
module PricesHelper

  def readable_promo_percentage price
    if price.amount > 0
      "#{(100 - (price.promo_amount * 100) / price.amount).to_i}%"
    end
  end

  def readable_amount amount
    if amount.nil?
      nil
    else
      ('%.2f' % amount).gsub('.', ',').gsub(',00', '')
    end
  end

end
