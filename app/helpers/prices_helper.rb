# encoding: utf-8
module PricesHelper

  def show_price price
    if price.promo_amount
      content_tag :span, class: 'pointer ', title: price.localized_libelle, data: { behavior: 'tooltip' } do
        return_string = content_tag :span, class: 'epsilon line-through pointer gray-light' do
          "#{readable_amount(price.amount)}€"
        end
        return_string += content_tag :span, class: 'gamma pointer green line-height-1' do
          "#{readable_amount(price.promo_amount)}€"
        end
        return_string
      end
    else
      content_tag :span, class: 'gamma pointer green line-height-1', title: price.localized_libelle, data: { behavior: 'tooltip' } do
        "#{readable_amount(price.amount)}€"
      end
    end
  end

  def readable_promo_percentage price
    if price.amount > 0
      "#{(100 - (price.promo_amount * 100) / price.amount).to_i}%"
    end
  end

  def readable_amount amount, round=false
    if amount.nil?
      nil
    elsif round
      amount.to_i
    else
      ('%.2f' % amount).gsub('.', ',').gsub(',00', '')
    end
  end

  # @duration: Duration in minute
  # Return a readable duration like 1h30
  def readable_duration duration
    "#{(duration / 60.0).floor}h#{duration % 60}"
  end
end
