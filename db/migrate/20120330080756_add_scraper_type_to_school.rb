class AddScraperTypeToSchool < ActiveRecord::Migration
  def self.up
    change_table :school do |t|
      t.string :scraper_type, limit: 15
    end
    School.reset_column_information
    s = School.where(:name => "Arizona State University").first
    s.scraper_type = "ASU"
    s.save!
    change_column :school, :scraper_type, :string, null: false
  end

  def self.down
    change_table :school do |t|
      t.remove :scraper_type
    end
  end
end
