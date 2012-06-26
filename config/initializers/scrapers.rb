Scrapers = Hash.new
Scrapers["ASU"] = AsuScheduleScraper.new
Scrapers["MOCK"] = MockScheduleScraper.new
Scrapers["YC"] = YcScheduleScraper.new
