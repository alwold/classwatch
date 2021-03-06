class School < ActiveRecord::Base
  self.table_name = :school
  self.primary_key = :school_id

  has_many :terms

  scope :active, -> { where(disable_adding: false) }
end
