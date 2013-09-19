# encoding: utf-8
class UserMailer < ActionMailer::Base
  layout 'email'

  helper :prices, :comments

  default from: "\"L'équipe de CoursAvenue.com\" <contact@coursavenue.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.book_class.subject
  #

  # Welcomes the user on the platforme
  def contact(name, email, content)
    @name    = name
    @email   = email
    @content = content
    mail to: 'contact@coursavenue', subject: 'Message de contact'
  end

  def welcome(user)
    @user = user
    mail to: @user.email, subject: 'Bienvenue sur CoursAvenue.com'
  end

  # Inform the user that the comment has correctly been submitted
  def congratulate_for_accepted_comment(comment)
    @comment   = comment
    @structure = @comment.structure
    mail to: @comment.email, subject: "Votre avis à propos de : #{@structure.name}"
  end

  def congratulate_for_comment(comment)
    @comment   = comment
    @structure = @comment.structure
    mail to: @comment.email, subject: "Votre avis à propos de : #{@structure.name}"
  end

  # Inform the user that the comment has been validated by the teacher
  def comment_has_been_validated(comment)
    @comment   = comment
    @structure = @comment.structure
    mail to: @comment.email, subject: "Votre avis à été validé !"
  end

  # Gives user information on establishment
  def alert_user_for_reservation(reservation)
    @reservation = reservation
    @structure   = @reservation.structure
    @user        = reservation.user

    mail to: @user.email,               subject: @reservation.email_subject_for_user
    mail to: 'nim.izadi@gmail.com',     subject: @reservation.email_subject_for_user if Rails.env.development?
  end

  # Inform establishment that someone wants to reserve a course
  def alert_structure_for_reservation(reservation)
    @reservation = reservation
    @user        = reservation.user
    @structure   = @reservation.structure

    mail to: @structure.contact_email, subject: @reservation.email_subject_for_structure
  end

  private
end
