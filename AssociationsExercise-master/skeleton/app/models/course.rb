class Course < ActiveRecord::Base
  has_many(
    :enrollments,
    class_name: 'Enrollment',
    primary_key: :id,
    foreign_key: :course_id
  )

  has_many(
    :students,
    through: :enrollments,
    source: :user
  )

  has_many(
    :child_courses,
    class_name: "Course",
    primary_key: :id,
    foreign_key: :prereq_id
  )

  belongs_to(
    :prerequisite,
    class_name: 'Course',
    primary_key: :id,
    foreign_key: :prereq_id
  )

  belongs_to(
    :instructor,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :instructor_id
  )

end
