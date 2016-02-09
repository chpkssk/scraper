require 'pry'
require 'csv'

file = File.new("title_walmart.csv","r")
walmart_title = []
amazon_title = []

company_hash = {}


while (line = file.gets)
	line.split(",").each do |t|
		walmart_title.push(t)
	end
end
file = File.new("title_amazon.csv","r")


while (line = file.gets)
	line.split("                                ").each do |t|
		amazon_title.push(t)
	end
end
file.close
Pry.start(binding)

amazon_title.each do |title|
	company_name = title.split.reject{|e| /"\""/ =~ e}[0]
	if !company_hash.include?(company_name)
		company_hash[company_name] = []
	end
	company_hash[company_name].push(title)
end
