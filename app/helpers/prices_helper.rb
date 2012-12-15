# encoding: utf-8
module PricesHelper
  def readable_price(price)
    case price.price_1
    when -1
      t('price.contact_structure')
    when 0
      t('price.free')
    else
      "#{price.price_1} € #{price.price_1_libelle}"
    end
  end

  def readable_promotion promotion
    if promotion.blank?
      ""
    else
      "#{(promotion * 100).to_i} %"
    end
  end
end
