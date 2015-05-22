class GiftCertificate::Voucher < ActiveRecord::Base
  belongs_to :gift_certificate
  belongs_to :user

  validates :gifted_to, presence: true

  delegate :amount, :structure, to: :gift_certificate

  # Retrieve the `Stripe::Charge` associated with the voucher.
  #
  # @return nil or Stripe::Charge
  def stripe_charge
    return nil if stripe_charge_id.nil?

    Stripe::Charge.retrieve(stripe_charge_id)
  end

  # Charge the amount of the voucher to the user.
  #
  # @param token The token needed to create the stripe customer, if it doesn't already exists.
  #
  # @return the charge or nil
  def charge!(token = nil)
    return nil if structure.can_receive_payments?

    customer = user.stripe_customer || user.create_stripe_customer(token)
    return nil if customer.nil?

    charge = Stripe::Charge.create({
      amount:   amount.to_i * 100,
      currency: GiftCertificate::CURRENCY,
      customer: customer.id,
      destination: structure.stripe_managed_account
    })

    self.stripe_charge_id = charge.id
    self.save

    charge
  end

  # Whether the voucher has been charged to the user.
  #
  # @return a Boolean
  def charged?
    stripe_charge_id.present?
  end
end
