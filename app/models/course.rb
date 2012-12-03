class Course < ActiveRecord::Base

  has_one :planning, dependent: :destroy
  has_one :price   , dependent: :destroy
  belongs_to :course_group

  attr_accessible :course_info_1,
                  :course_info_2,
                  :max_age_for_kid,
                  :min_age_for_kid,
                  :is_individual,
                  :annual_membership_mandatory,
                  :is_for_handicaped,
                  :registration_date,
                  :teacher_name

end
