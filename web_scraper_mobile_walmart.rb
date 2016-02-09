require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'

url = "http://www.walmart.com/search/?query=mobile%20phones&cat_id=3944_542371_1073085"
mobile_url = []
no_page = 2
#Pry.start(binding)
title = []
image = []
detail = []
url_list = []
i=0

while(no_page <= 51)
	sleep(2)
	puts no_page
	page = HTTParty.get(url)
	parse_page = Nokogiri::HTML(page)
	
	parse_page.css('div[class*="js-tile"] a[class *= "js-product-title"]').each do |t|
		url_list.push("http://www.walmart.com"+t['href'])
=begin
		sleep(2)
		url = "http://www.walmart.com"+t['href']
		page = HTTParty.get(url)
		mobile_page = Nokogiri::HTML(page)
		title.push(mobile_page.css('div[class*="Grid-col"] h1[class*="js-product-heading"]').text.gsub("  ",""))
		puts title.last
		image.push(mobile_page.css('div[class*="product-image-vp"] img')[0]['src'])
		temp = ""
		mobile_page.css('div[class*="product-specs-section"] tr[class="js-product-specs-row"]').each do |t|
			temp = temp + t.text.gsub("\n","") +","
		end
		temp += "\n"

		detail.push(temp)
=end
	end
#			Pry.start(binding)

	url = "http://www.walmart.com/search/?query=mobile%20phones&page=#{no_page}&cat_id=3944_542371_1073085"
	no_page = no_page + 1

end

CSV.open("url_walmart.csv","w") do |csv|
	csv << url_list
end

=begin
CSV.open("title_walmart.csv","w") do |csv|
	csv << title
end

CSV.open("image_walmart.csv","w") do |csv|
	csv << image
end

CSV.open("details_walmart.csv","w") do |csv|
	csv << image
end
=end