module CoursesHelper

  def join_teachers(course)
    course.plannings.collect{|p| p.teacher.try(:name)}.compact.uniq.join(', ')
  end

  def join_course_subjects(course, with_h3 = false)
    course.subjects_string.split(';').collect do |subject_string|
      subject_name, subject_slug = subject_string.split(',')
      content_tag(:li) do
        content_tag((with_h3 ? :h3: :span), class: 'flush--bottom line-height-1') do
          link_to subject_name, subject_courses_path(subject_slug), class: 'lbl milli inline subject-link'
        end
      end
    end.join(' ').html_safe
  end

  def join_audiences_text(course)
    course.audiences.map(&:name).map{|name| t(name)}.join(', ')
  end

  def join_levels_text(course)
    course.levels.map(&:name).map{|name| t(name)}.join(', ')
  end

  def join_audiences(course)
    content_tag :ul, class: 'nav' do
      course.audiences.order(:order).collect do |audience|
        content_tag(:li, t(audience.name))
      end.join(', ').html_safe
    end
  end

  def join_levels(course)
    content_tag :ul, class: 'nav' do
      course.levels.order(:order).collect do |level|
        content_tag(:li, t(level.name))
      end.join(', ').html_safe
    end
  end

  def join_week_days(course, options={})
    week_days = []
    week_days = course.plannings.order(:week_day).collect do |planning|
      planning.week_day
    end.compact.uniq
    class_names = 'nav week_days '
    class_names << options[:class]
    content_tag :ul, class: class_names do
      week_days.collect do |week_day|
        content_tag(:li, t('date.day_names')[week_day])
      end.join(', ').html_safe
    end
  end
end
