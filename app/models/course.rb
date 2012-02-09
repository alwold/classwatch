class Course < ActiveRecord::Base
  belongs_to :institution
  belongs_to :user
end
