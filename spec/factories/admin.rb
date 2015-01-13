
# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :admin do
    structure

    name     { Faker::Name.name }
    email    { Faker::Internet.email }

    phone_number            '0104050104'
    mobile_phone_number     '0604050104'

    confirmed_at { Date.today }

    password                'zpdajdpzaojdxd'
    password_confirmation   'zpdajdpzaojdxd'

    factory :admin_from_facebook do
      uid              { Faker::Number.number(6) }
      oauth_token      { Faker::Internet.password }
      oauth_expires_at { 10.years.from_now }
      provider 'facebook'
    end
  end
end
