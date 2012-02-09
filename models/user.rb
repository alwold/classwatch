class User < ActiveRecord::Base
  has_and_belongs_to_many :courses, { :join_table => "user_course" }
  set_primary_key "user_id"
end
