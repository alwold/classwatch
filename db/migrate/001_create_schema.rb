class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :school, primary_key: :school_id do |t|
      t.string :name, limit: 255, null: false
    end

    create_table :term, primary_key: :term_id do |t|
      t.string :term_code, limit: 10
      t.string :name, limit: 100, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.belongs_to :school
    end

    create_table :course, primary_key: :course_id do |t|
      t.string :course_number, limit: 15, null: false
      t.belongs_to :term
    end

    add_index :course, [:term_id, :course_number], unique: true

    create_table :notification, primary_key: :notification_id do |t|
      t.belongs_to :course
      t.belongs_to :user
      t.timestamp :notification_timestamp
      t.string :type, limit: 50
      t.string :status, limit: 10, null: false
      t.integer :attempts, null: false
      t.string :info, limit: 255, null: true
      t.timestamp :last_attempt
    end

    create_table :users, primary_key: :user_id do |t|
      t.string :phone, limit: 25, null: true
    end

    create_table :user_course do |t|
      t.boolean :notified, null: false
      t.boolean :paid, null: false
      t.belongs_to :user
      t.belongs_to :course
    end

    add_index :user_course, [:user_id, :course_id], unique: true

    create_table :notifier_setting, primary_key: :notifier_setting_id do |t|
      t.string :type, limit: 50
      t.boolean :enabled, null: false
      t.belongs_to :user_course
    end
  end

  def self.down
    drop_table :notifier_setting
    drop_table :user_course
    drop_table :users
    drop_table :notification
    drop_table :course
    drop_table :term
    drop_table :school
  end
end
