if RUBY_PLATFORM == "java"
  Dir.entries("#{Rails.root}/lib").sort.each do |entry|
    if entry =~ /.jar$/
      require entry
    end
  end
end
