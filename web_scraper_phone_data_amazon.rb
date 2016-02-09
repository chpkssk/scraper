require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'

file = File.new("mobile_url.txt","r")
all_url = []

while (line = file.gets)
	line.split(",").each do |t|
		all_url.push(t.split("\"").find{ |e| /http/ =~ e})
	end
end
file.close

title = []
image = []
detail = []

i = 0

all_url.each do |url|
	sleep(2)
	page = HTTParty.get(url, headers: {"User-Agent"=> "My Application #{i}"})
	parse_page = Nokogiri::HTML(page)

	title.push(parse_page.css('div#titleSection').text.gsub("\n",''))
	puts title.last
	image.push(parse_page.css('div#imgTagWrapperId[class *="imgTagWrapper"] img')[0]['data-a-dynamic-image'].split("\"").find{|e| /http/ =~ e })
	temp = ""
	parse_page.css('div#detail-bullets div[class="content"] li').each do |t|
 		temp = temp + t.text.gsub("\n\n","").gsub("   ","") + "," unless t.text.include?("Customer")
	end
	temp = temp + "\n"
	detail.push(temp)

	if(i == 10)
		CSV.open("title_amazon.csv","a+") do |csv|
			csv << title
		end
		CSV.open("image_amazon.csv","a+") do |csv|
			csv << image
		end
		CSV.open("details_amazon.csv","a+") do |csv|
			csv << detail
		end
		title = []
		image = []
		detail = []
		i = 0;
	end
	i = i + 1
end

CSV.open("title_amazon.csv","a+") do |csv|
	csv << title
end

CSV.open("image_amazon.csv","a+") do |csv|
	csv << image
end

CSV.open("details_amazon.csv","a+") do |csv|
	csv << detail
end