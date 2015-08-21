#encoding: utf-8

require 'nokogiri'
# require 'mail'
# require 'base64'

txt = File.open("dir/output.txt", "w+")
Dir.foreach("C:/D/WSH/ruby/ResumeReader") do |d|
	
  if d == '.' or d == '..' 
    
	elsif File.extname(d) == ".html"
		#Dir.mkdir("dir")
		# p zhilian_reader(d)
		txt.puts(zhilian_reader(d))
		
	elsif File.extname(d) == ".mht"
		html_part = wuyou_reader(d).parts[0]
		encoding = html_part.content_type_parameters['charset']
		puts encoding
		test = html_part.body.decoded.force_encoding(encoding).encode('utf-8')
		
		puts test
		
		txt.puts(test)
		
  end
	
	
  
  def zhilian_reader(d)
    f = File.open(d)
    doc = Nokogiri::HTML(f)
    f.close
    # puts doc	
	
	name = doc.css(".main-title-fl").first.nil? ? "" : doc.css(".main-title-fl").first.content 
       
    name_f = name.gsub(' ','')
    #puts name_f
    # puts doc.inspect
    phone = doc.css(".main-title-fr").first.nil? ? "" : doc.css(".main-title-fr").first.content
    phone_f = phone.gsub(/\D/,'')
    #puts phone_f
	
	period = ""
    summary = doc.css(".summary-top span").first.nil? ? nil : doc.css(".summary-top span").first.content
	unless summary.nil?
		#puts '\u00a0\u7537'.encode
		
		#puts "%04x" % summary.unpack("U*")[0]
		
		period = summary.match(/\S+工作经验/).to_s.gsub(/\u00a0/, ' ').match(/\S+$/).to_s
		#puts period
		
	end
	
	#puts doc.css(".summary-top").first.content
	city = doc.css(".summary-top").first.nil? ? "" : doc.css(".summary-top").first.content.match(/现居住地\S+/).to_s.gsub(' ','')[5..-1]
	# puts city_r.inspect
	# city = city_r.gsub(' ','')[5..-1]
	#puts city
	
	if position_r = doc.css(".resume-preview-all h5")
	  position_f = '' 
	elsif
	  # position = position_r.first.content
	  position_f = position_r.first.content.match(/.+\|/).to_s[0..-2]
	end
	#puts position_f
	
	quality_r = doc.css(".resume-preview-all")
	# puts quality_r.first.css("h3")
	# puts quality_r
	
	quality_f = []
	education_f = []
	quality_r.each do |q|
	  q_item = q.css("h3").first.content
	  if q_item.include?('专业技能')
	   # p q.css(".resume-preview-dl").first.content
		quality_f = q.css(".resume-preview-dl").first.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
	  elsif q_item.include?('教育经历')
		education_f = q.css(".resume-preview-dl").first.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
	  end
	end
	# puts name_f
	return [name_f, phone_f, city, period, position_f, quality_f, education_f]
end

def wuyou_reader(d)
	f = Mail.read(d)
	return f

end
 
  # def wuyou_reader(d)
    # f = File.open(d)
    # doc = Nokogiri::HTML(f)
    # f.close
    # # p doc	
	# # p doc.css("tr")
	# name = doc.css("tr td span b").first.nil? ? "" : doc.css("tr td span b").first.content 
       
    # name_f = name.gsub(' ','')
    # # puts name_f
    # # puts doc.inspect
    # phone = doc.css(".main-title-fr").first.nil? ? "" : doc.css(".main-title-fr").first.content
    # phone_f = phone.gsub(/\D/,'')
    # #puts phone_f
	
	# period = ""
    # summary = doc.css(".summary-top span").first.nil? ? nil : doc.css(".summary-top span").first.content
	# unless summary.nil?
		# #puts '\u00a0\u7537'.encode
		
		# #puts "%04x" % summary.unpack("U*")[0]
		
		# period = summary.match(/\S+工作经验/).to_s.gsub(/\u00a0/, ' ').match(/\S+$/).to_s
		# #puts period
		
	# end
	
	# #puts doc.css(".summary-top").first.content
	# city = doc.css(".summary-top").first.nil? ? "" : doc.css(".summary-top").first.content.match(/现居住地\S+/).to_s.gsub(' ','')[5..-1]
	# # puts city_r.inspect
	# # city = city_r.gsub(' ','')[5..-1]
	# #puts city
	
	# if position_r = doc.css(".resume-preview-all h5")
	  # position_f = '' 
	# elsif
	  # # position = position_r.first.content
	  # position_f = position_r.first.content.match(/.+\|/).to_s[0..-2]
	# end
	# #puts position_f
	
	# quality_r = doc.css(".resume-preview-all")
	# # puts quality_r.first.css("h3")
	# # puts quality_r
	
	# quality_f = []
	# education_f = []
	# quality_r.each do |q|
	  # q_item = q.css("h3").first.content
	  # if q_item.include?('专业技能')
	   # # p q.css(".resume-preview-dl").first.content
		# quality_f = q.css(".resume-preview-dl").first.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
	  # elsif q_item.include?('教育经历')
		# education_f = q.css(".resume-preview-dl").first.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
	  # end
	# end
	# # puts name_f
	# # return [name_f, phone_f, city, period, position_f, quality_f, education_f]
	# return doc.inspect
  # end
	
	
end

txt.close






# position_r.each do |p|
#   p.content.match()
#   puts p.content
# end
#puts position_r