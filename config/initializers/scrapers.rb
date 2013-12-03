Scrapers = Hash.new
Scrapers["ASU"] = AsuScheduleScraper.new
if defined?(MockScheduleScraper)
  Scrapers["MOCK"] = MockScheduleScraper.new
end
Scrapers["YC"] = YcScheduleScraper.new
Scrapers["UOREGON"] = UoregonScheduleScraper.new
Scrapers["CSUSB"] = CsusbScheduleScraper.new
Scrapers["SADDLEBACK"] = SaddlebackScheduleScraper.new
Scrapers["UWEST"] = UwestScheduleScraper.new
Scrapers['WELLESLEY'] = WellesleyScheduleScraper.new
Scrapers['ELAC'] = ElacScheduleScraper.new