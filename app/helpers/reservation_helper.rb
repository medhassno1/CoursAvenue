module ReservationHelper

  def reservable_path reservation
    reservable = reservation.reservable
    case reservation.reservable_type
    when 'Course', 'Course::Training', 'Course::Lesson'
      structure_course_path reservable.structure, reservable
    when 'Planning'
      structure_course_path reservable.course.structure, reservable.course
    when 'Place'
      structure_path reservable
    else
      root_path
    end
  end
end
