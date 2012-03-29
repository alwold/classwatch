class PopulateSetupData < ActiveRecord::Migration
  def up
    s = School.new
    s.name = "Arizona State University"
    s.save

    t = Term.new
    t.term_code = "2124"
    t.name = "Summer 2012"
    t.end_date = Date.new 2012, 5, 22
    t.start_date = Date.new 2012, 2, 6
    t.school = s
    t.save

    t = Term.new
    t.term_code = "2127"
    t.name = "Fall 2012"
    t.start_date = Date.new 2012, 5, 1
    t.end_date = Date.new 2012, 9, 1
    t.school = s
    t.save
  end

  def down
    Term.all.each do |t|
      t.delete
    end
    School.all.each do |s|
      s.delete
    end
  end
end
