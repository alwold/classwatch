SPRING_XML_CONFIG_FILES = %w(
     config/applicationContext
     classwatchDao).map { |c|
   "classpath:#{c}.xml" 
 }.to_java :string
 
 SPRING_CONTEXT = org.springframework.context.support.
   ClassPathXmlApplicationContext.new(SPRING_XML_CONFIG_FILES)
