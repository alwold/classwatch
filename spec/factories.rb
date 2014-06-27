FactoryGirl.define do
  factory :school do
    name 'Bla School'
    scraper_type 'BLA'
    disable_adding false
    disable_watching false
  end

  factory :user do
    email 'johndoe@gmail.com'
    password 'abc123'
  end

  factory :term do
    term_code '2147'
    name 'Fall 2014'
    start_date Date.new(2014, 6, 1)
    end_date Date.new(2014, 11, 1)
    school
  end
end
