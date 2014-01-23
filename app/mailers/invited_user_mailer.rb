# encoding: utf-8
class InvitedUserMailer < ActionMailer::Base

  layout 'email'

  default from: "\"L'équipe de CoursAvenue.com\" <contact@coursavenue.com>"

  def recommand_friends(invited_user)
    @invited_user = invited_user
    @email_text   = invited_user.email_text
    @email        = invited_user.email
    @referrer     = invited_user.referrer
    mail to: @email,
         subject: "#{@referrer.name} vous invite à créer votre profil sur CoursAvenue.",
         template_name: "#{invited_user.type.split('::').last.downcase}/recommand_friends"
  end

  def inform_invitation_success(invited_user)
    @referrer      = invited_user.referrer
    @invited_email = invited_user.email
    @show_links    = true
    referrer_email = (invited_user.referrer_type == 'Structure' ? @referrer.main_contact.email : @referrer.email)
    mail to: referrer_email, subject: "Félicitations ! Votre parrainage a bien été pris en compte",
         template_name: "#{invited_user.type.split('::').last.downcase}/inform_invitation_success"
  end

  def send_invitation_stage_1(invited_user)
    @referrer      = invited_user.referrer
    @invited_email = invited_user.email
    mail to: invited_email, subject: "#{referrer.name} vous invite à créer votre profil sur CoursAvenue.",
         template_name: "#{invited_user.type.split('::').last.downcase}/send_invitation_stage_1"
  end

  def send_invitation_stage_2(invited_user)
    @referrer      = invited_user.referrer
    @invited_email = invited_user.email
    mail to: invited_email, subject: "#{referrer.name} vous invite à créer votre profil sur CoursAvenue.",
         template_name: "#{invited_user.type.split('::').last.downcase}/send_invitation_stage_2"
  end
end
