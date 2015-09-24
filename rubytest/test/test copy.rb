#encoding: utf-8

require 'nokogiri'
require 'mail'
require 'base64'

txt = File.open("dir/output.txt", "w+")
Dir.foreach("/Users/neverabbit/workspace/ResumeReader/rubytest/test/resume") do |d|
  d = File.join('/Users/neverabbit/workspace/ResumeReader/rubytest/test/resume', d)
	
  if d == '.' or d == '..' 
    
	elsif File.extname(d) == ".html"
		#Dir.mkdir("dir")
		# p zhilian_reader(d)
		txt.puts(zhilian_reader(d))
		
	elsif File.extname(d) == ".mht"
		html_part = wuyou_reader(d).parts[0]
		encoding = html_part.content_type_parameters['charset']
		# puts encoding
		test = html_part.body.decoded.force_encoding(encoding).encode('utf-8')
		
		
		doc = Nokogiri::HTML(test)
		
		name_r = doc.xpath("//span[@style='font-size:25px;height:30px;line-height:30px;']")
		name = name_r.xpath("//b").first.nil? ? "" : name_r.xpath("//b").first.content
		
		phone = ""
		phone_r = doc.xpath("//tr/td[@colspan='2' and @valign='top']/table[@width='100%' and @border='0' and @cellspacing='0' and @cellpadding='0']/tr")
		phone_r.each do |p|
			desc = p.xpath("td")
			if !desc.first.nil? and desc.first.content.include?('电')
				phone = desc.last.content.match(/\d+/).to_s
			end
		end
		# /td[@height='20' and @colspan='3']
		# puts phone_r
		
		# phone = phone_r.first.nil? ? "" : phone_r.first.content
		
		# p phone
		
		city_r = doc.xpath("//td[@width='42%']")
		city = city_r.first.nil? ? "" : city_r.first.content
		
		education_r = doc.xpath("//tr/td/table[@width='100%' and @border='0' and @cellspacing='0' and @cellpadding='0' and @class='table_set']/tr")
		
		# p education_r
		# p education_r.length
		education_time = []
		education_uni = []
		education_degree = []
		education_subject = []
		education = []
		education_r.each do |e|
		# txt.puts(e)
		# txt.puts('\n\t')
		# puts e
			education_time_r = e.xpath("td[@width='26%' and @class='text_left']")
			
			 # p education_time_r.first
			unless education_time_r.first.nil?
				education_time << education_time_r.first.content.gsub(/\s/, '')
				education_uni_r = e.xpath("td[@width='30%' and @class='text']")
				education_uni << education_uni_r.first.content.gsub(/\s/, '')
				 # puts education_uni_r
				education_subject << education_uni_r.last.content.gsub(/\s/, '')
				education_degree_r = e.xpath("//td[@width='14%' and @class='text']")
				education_degree << education_degree_r.first.content.gsub(/\s/, '')
				# puts education_uni_r
			end
		end
		
		education = [education_time, education_uni, education_subject, education_degree].transpose
		# p education_time
		# p education_uni
		# p education_degree
		# p education
		
		
		experience_r = doc.xpath("//table[@width='97%' and @align='center' and @cellspacing='0' and @cellpadding='0' and @border='0']")
		experience_r.each do |e|
			title = e.xpath("tr/td[@class='cvtitle' and @valign='middle' and @align='left']").first.content unless e.xpath("tr/td[@class='cvtitle' and @valign='middle' and @align='left']").first.nil?
			# p title
			if title == "工作经验"
        # experience_m =
        p 1
			end
		end
		
		 # education_r.last.xpath("//td[@width='26%' and @class='text_left']")
		
		
		
		
		# education_time_r = education_r.xpath("//td[@width='26%' and @class='text_left']")
		# education_time = []
		# education_time_r.each do |t| 
			# # t = e.xpath("//td[@width='26%' and @class='text_left']")
			# education_time << t.content.gsub(/\s/, '') unless t.nil?
		# end
		# # first.content
		# p education_time
		
		# education_uni_r = education_r.xpath("//td[@width='30%' and @class='text']")
		# puts education_uni_r
		# education_uni = []
		# education_uni_r.each do |u|
			# education_uni << u.content.gsub(/\s/, '') unless u.nil?
		# end
		# education_uni = education_uni.each_slice(education_uni.length/2).to_a.transpose
		
		# education_degree_r = education_r.xpath("//td[@width='14%' and @class='text']")
		# education_degree = []
		# education_degree_r.each do |d|
			# education_degree << d.content.gsub(/\s/, '') unless d.nil?
		# end
		
		# p education_uni
		# puts education_uni.length
		
		# education_r_time = doc.xpath("//tr/td/table[@width='100%' and @border='0' and @cellspacing='0' and @cellpadding='0' and @class='table_set']/tr/td[@width='26%' and @class='text_left']")
		
		# education = education_r.first.nil? ? "" : education_r.first.content.gsub(/\s/,'')
		# puts education

		
		
		
		
		
		
		txt.puts(name)
		txt.puts(city)
		txt.puts(education)

		
  end
	
	
  
  def zhilian_reader(d)
    f = File.open(d)
    doc = Nokogiri::HTML(f)
    f.close
	
		# txt1 = File.open("dir/output_raw.txt", "w+")
     # txt1.puts(doc)	
		# txt1.close
	
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
	# f = Nokogiri::HTML(f)
	
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