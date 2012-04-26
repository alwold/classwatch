class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key "course_status", "course", :name => "course_status_course_id_fk", :primary_key => "course_id"
    add_foreign_key "course", "term", :name => "course_term_id_fk", :primary_key => "term_id"
    add_foreign_key "notification", "course", :name => "notification_course_id_fk", :primary_key => "course_id"
    add_foreign_key "notification", "users", :name => "notification_user_id_fk", :primary_key => "user_id"
    add_foreign_key "notifier_setting", "user_course", :name => "notifier_setting_user_course_id_fk"
    add_foreign_key "term", "school", :name => "term_school_id_fk", :primary_key => "school_id"
    add_foreign_key "user_course", "course", :name => "user_course_course_id_fk", :primary_key => "course_id"
    add_foreign_key "user_course", "users", :name => "user_course_user_id_fk", :primary_key => "user_id"
  end
end
