require 'pry'
require 'csv'

#file = File.new("title_walmart1.csv","r")
walmart_title = []
amazon_title = []

amazon_hash = {}
walmart_hash={}

$threshold = 5
=begin
while (line = file.gets)
	line.split("-1-1-1-1").each do |t|
		walmart_title.push(t)
	end
end
=end

CSV.foreach("title_walmart.csv") do |row|
	walmart_title.push(row)
end

CSV.foreach("title_amazon.csv") do |row|
	amazon_title.push(row)
end
#Pry.start(binding)

def get_score(title, name)
	max = 0
	counter = 0
	index = -1
	title = title.split

	name.each_with_index do |mobile,i|
		title.each do |compare|
			if( mobile.join().include? compare)
				counter +=1
			end
		end
		if max < counter
			max = counter
			index = i
		end
		counter = 0
	end

	if(max > $threshold)
		return index
	else
		return -1
	end
end

amazon_title.flatten.each do |title|
	name = title.gsub("   ","").split(" ")
	company_name = name[0].downcase
	if !amazon_hash.include?(company_name)
		amazon_hash[company_name.downcase] = []
	end
		amazon_hash[company_name.downcase].push(name)
end

=begin
walmart_title.flatten.each do |title|
	company_name = title.split(" ")[0].downcase
	if !walmart_hash.include?(company_name)
		walmart_hash[company_name] = []
	end
		walmart_hash[company_name].push(title)
end
=end

CSV.open("similar_mobile.csv","a") do |csv|
	walmart_title.flatten.each do |title|
		company_name = title.split(" ")[0].downcase
		if amazon_hash.key? company_name
			value = get_score(title, amazon_hash[company_name])
			if value != -1
 			  csv << ["walmart",title]
 			  csv << ["amazon",amazon_hash[company_name][value].join(" ")]
			end
		end
	end
end
