class Course::Training < Course

  def is_training?
    true
  end

  def length
    plannings.first.length
  end

  def type_name
    'Stage'
  end

end
