class AddAsuTerms < ActiveRecord::Migration
  def up
    s = School.where(name: 'Arizona State University').first
    t = Term.new
    t.school = s
    t.name = "Spring 2013"
    t.term_code = "2131"
    t.start_date = Date.new(2012, 10, 22)
    t.end_date = Date.new(2013, 4, 30)
    t.save!

    t = Term.new
    t.school = s
    t.name = "Summer 2013"
    t.term_code = "2134"
    t.start_date = Date.new(2013, 2, 13)
    t.end_date = Date.new(2013, 8, 13)
    t.save!

    t = Term.new
    t.school = s
    t.name = "Fall 2013"
    t.term_code = "2137"
    t.start_date = Date.new(2013, 3, 4)
    t.end_date = Date.new(2013, 12, 6)
    t.save!
  end

  def down
    s = School.where(name: 'Arizona State University').first
    Term.where(school_id: s, term_code: ['2131', '2134', '2137']).destroy_all
  end
end
