# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    commentable {FactoryGirl.create(:structure)}
    user
    title       Faker::Lorem.sentence(4)

    after(:build) do |course|
      course.subjects << Subject.at_depth(2).first
    end

    # Comment contact
    author_name     { Faker::Name.name }
    email           { Faker::Internet.email }

    # Comment content
    course_name       Faker::Lorem.sentence(4)
    content           Faker::Lorem.sentence(40)
    # rating          [1,2,3,4,5].sample

    factory :accepted_comment do
      status 'accepted'
    end
  end
end
