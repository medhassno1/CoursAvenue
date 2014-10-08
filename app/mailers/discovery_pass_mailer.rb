# encoding: utf-8
class DiscoveryPassMailer < ActionMailer::Base
  include ::ActionMailerWithTextPart
  include Roadie::Rails::Automatic

  layout 'email'

  default from: "\"L'équipe CoursAvenue\" <contact@coursavenue.com>"

  ######################################################################
  # DiscoveryPass                                                     #
  ######################################################################
  def your_discovery_pass_is_active(discovery_pass)
    @discovery_pass = discovery_pass
    @user           = discovery_pass.user
    mail to: @user.email, subject: "Félicitations ! Votre Pass Découverte est activé"
  end

  def you_deactivated_your_pass(discovery_pass)
    @discovery_pass = discovery_pass
    @user           = discovery_pass.user
    mail to: @user.email, subject: "Résiliation de votre Pass Découverte"
  end

  def five_days_before_renewal(discovery_pass)
    @discovery_pass = discovery_pass
    @user           = discovery_pass.user
    mail to: @user.email, subject: "Renouvellement de votre Pass Découverte"
  end

  def your_pass_renewed(discovery_pass)
    @discovery_pass = discovery_pass
    @user           = discovery_pass.user
    mail to: @user.email, subject: "Renouvellement de votre Pass Découverte"
  end

  def your_sponsorship_is_active(discovery_pass)
    @discovery_pass = discovery_pass
    @sponsored_user = discovery_pass.user
    @sponsor        = discovery_pass.sponsorship.user
    mail to: @sponsor.email, subject: "Votre Parrainage a été prit en compte"
  end
end
