class PriceSerializer < ActiveModel::Serializer
  include PricesHelper

  # cached
  # delegate :cache_key, to: :object

  attributes :id, :libelle, :amount, :info, :promo_percentage, :promo_amount, :promo_amount_type,
             :libelle_type, :is_free, :discount, :is_registration

  def libelle_type
    case object.type
    when 'Price::Trial'
      'Spéciale découverte'
    when 'Price::PremiumOffer'
      'Offre spéciale'
    when 'Price::Discount'
      'Tarif réduit'
    else
      'Tarif normal'
    end
  end

  def info
    if object.discount? and object.libelle != 'prices.discount.other'
      str = "Pour les "
      str << I18n.t("#{object.libelle}_plural")
      str << ". #{object.info}" if object.info.present?
      str
    else
      object.info
    end
  end

  def libelle
    case object.type
    when 'Price::BookTicket'
      if object.number == 1
        '1 cours'
      else
        "Carnet de #{object.number} tickets"
      end
    else
      I18n.t(object.libelle) if object.libelle
    end
  end

  def is_free
    return (object.amount.nil? or object.amount == 0)
  end

  def is_registration
    object.registration?
  end

  def discount
    object.discount?
  end
end
