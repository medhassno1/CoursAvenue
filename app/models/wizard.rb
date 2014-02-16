# encoding: utf-8
class Wizard < ActiveHash::Base

  self.data = [
    {
        id: 1,
        name: 'wizard.description',
        partial: 'wizards/description',
        show_save: true,
        completed?: lambda {|structure| structure.description.present? }
    },
    {
        id: 2,
        name: 'wizard.logo',
        partial: 'wizards/logo',
        show_save: true,
        completed?: lambda {|structure| structure.logo? }
    },
    {
        id: 3,
        name: 'wizard.coordonates',
        partial: 'wizards/coordonates',
        show_save: true,
        completed?: lambda {|structure| structure.contact_phone.present? or structure.contact_mobile_phone.present? or structure.contact_email.present? }
    },
    {
        id: 4,
        name: 'wizard.places',
        partial: 'wizards/places',
        show_save: true,
        completed?: lambda {|structure| structure.has_only_one_place? or structure.places.count > 1 }
    },
    {
        id: 5,
        name: 'wizard.recommendations',
        partial: 'wizards/recommendations',
        show_save: true,
        completed?: lambda {|structure| structure.comments.any? or structure.comment_notifications.any? }
    },
    {
        id: 6,
        name: 'wizard.widget_status',
        partial: 'wizards/widget_status',
        show_save: false,
        completed?: lambda {|structure| structure.comments_count < 5 or (structure.comments_count >= 5 and !structure.widget_status.blank?) }
    },
    {
        id: 7,
        name: 'wizard.widget_url',
        partial: 'wizards/widget_url',
        show_save: true,
        completed?: lambda {|structure| structure.widget_url.present? or (structure.comments_count < 5 or (structure.comments_count > 5 and !structure.has_installed_widget?)) }
    }
  ]
end

