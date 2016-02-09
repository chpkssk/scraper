require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'

url = "http://www.amazon.com/s/ref=sr_1_1_hso_sc_smartcategory_2?rh=n%3A2407749011%2Ck%3Amobile+phones&keywords=mobile+phones&ie=UTF8&qid=1454843899&sr=8-1-acs"
mobile_url = []
no_page = 2

while(no_page <= 267)
	sleep(4)
	page = HTTParty.get(url)
	parse_page = Nokogiri::HTML(page)
	
	parse_page.css('li[class*="s-result"] div[class*="a-row a-spacing-none"] a[class*="a-link-normal s-access-detail"]').each do |t|
		mobile_url.push(t['href'])
	end
	
	#url = ''
	#if !parse_page.css('div#pagn span[class="pagnRA"] a').empty?
	#	url = "http://www.amazon.com" + parse_page.css('div#pagn span[class="pagnRA"] a')[0]['href']
	#	next_url.push(url)
	#end

	if(no_page %20 == 0)
		sleep(5)
		File.open("mobile_url.txt", 'a') { |file| file.write(mobile_url) }
		File.open("mobile_url.txt", 'a') { |file| file.write("\n") }
		mobile_url = []
	end
	
	url = "http://www.amazon.com/s?ie=UTF8&page=#{no_page}&rh=n%3A2407749011%2Ck%3Amobile%20phones"
	no_page = no_page + 1
end
File.open("mobile_url.txt", 'a') { |file| file.write(mobile_url) }
File.open("mobile_url.txt", 'a') { |file| file.write("\n") }