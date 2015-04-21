class Pro::SubscriptionsCouponsController < Pro::ProController
  before_action :authenticate_pro_super_admin!

  def index
    @coupons = Subscriptions::Coupon.all
  end

  def new
    @coupon  = Subscriptions::Coupon.new
    @showing = false

    if request.xhr?
      render layout: false
    end
  end

  def create
    @coupon = Subscriptions::Coupon.new(permitted_params)

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to pro_subscriptions_coupons_path, notice: 'Code promo bien créé' }
        format.js
      else
        format.html { render action: :new }
        format.js
      end
    end
  end

  def show
    @coupon = Subscriptions::Coupon.find(params[:id])
    @showing = true

    if request.xhr?
      render layout: false
    end
  end

  private

  def permitted_params
    params.require(:subscriptions_coupon).permit(:name, :amount, :duration)
  end
end
