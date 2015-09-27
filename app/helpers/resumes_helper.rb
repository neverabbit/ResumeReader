module ResumesHelper
  

  
  # get the desired information from original resume
  def resume_import_zhilian(resume_file_path)
    
    #encoding: utf-8

    require 'nokogiri'
        f = File.open(resume_file_path)
        doc = Nokogiri::HTML(f)
        f.close
        name = "无法获取"
        name = doc.css(".main-title-fl").first.content.gsub(' ','')
  
        phone = doc.css(".main-title-fr").first.content.gsub(/\D/,'')
        # phone_f = phone.gsub(/\D/,'')
        #puts phone_f
    
        summary = doc.css(".summary-top span").first.content
        #puts '\u00a0\u7537'.encode
    
        #puts "%04x" % summary.unpack("U*")[0]
    
        period = summary.match(/\S+工作经验/).to_s.gsub(/\u00a0/, ' ').match(/\S+$/).to_s.match(/\d+/).to_s
        #puts period
    
        #puts doc.css(".summary-top").first.content
        city = doc.css(".summary-top").first.content.match(/现居住地\S+/).to_s.gsub(' ','')[5..-1]
        # puts city_r.inspect
        # city = city_r.gsub(' ','')[5..-1]
        #puts city
        position_r = doc.css(".resume-preview-all h5")
        if !position_r.first.nil?
          position = position_r.first.content.match(/.+\|/).to_s[0..-2] 
        else
          # position = position_r.first.content
          position = ''
        end
        #puts position_f
    
        quality_r = doc.css(".resume-preview-all")
        # puts quality_r.first.css("h3")
        # puts quality_r
        quality = []
        education = []
        experience = []
        quality_r.each do |q|
          q_item = q.css("h3").first.content
          if q_item.include?('专业技能')
           # p q.css(".resume-preview-dl").first.content
            quality = q.css(".resume-preview-dl").first.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
          elsif q_item.include?('教育经历')
            education = q.css(".resume-preview-dl").first.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
          elsif q_item.include?('工作经历')
            company = []
            responsibility = []
            q.css("h2").each do |h2| 
              company << h2.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
            end
            q.css("h5").each do |h5|
              responsibility << h5.content.gsub(/\t|\r/,'').split(/\n/).delete_if {|q| q.empty? }
            end
            experience = [company, responsibility].transpose
          end
        end
        return { name: name, phone: phone, city: city, position: position, period: period, quality: quality, education: education, experience: experience }
  end
  
  def resume_import_wuyou(resume_file_path)
    
    #encoding: utf-8

    require 'nokogiri'
    
    html_part = Mail.read(resume_file_path).parts[0]
    if !html_part.nil?
  		encoding = html_part.content_type_parameters['charset']
  		# puts encoding
  		test = html_part.body.decoded.force_encoding(encoding).encode('utf-8', invalid: :replace, undef: :replace)
		
		
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
		
  		experience_r = doc.xpath("//table[@width='97%' and @align='center' and @cellspacing='0' and @cellpadding='0' and @border='0']/tr[contains(td[@class='cvtitle' and @valign='middle' and @align='left'], '工作经验')]/following-sibling::tr[3]")
		
  		company_r = experience_r.xpath("td/table/tr[contains(td, '所属行业：')]/preceding-sibling::tr[1]")
  		company = []
  		company_r.each do |c|
  			company << c.content.gsub(/\s/, '') unless c.nil?
  		end
  		responsibility_r = experience_r.xpath("td/table/tr[contains(td, '所属行业：')]/following-sibling::tr[1]")
  		department = []
  		position_e = []
  		responsibility_r.each do |r|
  			department << r.xpath("td[@class='text_left']").first.content.gsub(/\s/, '') unless r.xpath("td[@class='text_left']").first.nil?
  			position_e << r.xpath("td[@class='text']").first.content.gsub(/\s/, '') unless r.xpath("td[@class='text']").first.nil?
  		end	
  		position = position_e.empty? ? "" : position_e[0]
		
  		if !company.empty?
  			period_start = company.last[0..3].to_i
  			this_year = Date.today.year
  			period = (this_year - period_start).to_s
  		else
  			period = ''
  		end
		
  		experience = [company, department, position_e].safe_transpose

  		quality_r = doc.xpath("//table[@width='97%' and @align='center' and @cellspacing='0' and @cellpadding='0' and @border='0']/tr[contains(td[@class='cvtitle' and @valign='middle' and @align='left'], 'IT')]/following-sibling::tr[3]")
		
  		quality_r = quality_r.xpath("td/table/tr/td[@class='text_left']")
  		quality = []
  		quality_r.each do |q|
  			quality << q.content.gsub(/\s/, '') unless q.nil?
  		end
  		quality.delete_at(0)
 
      return { name: name, phone: phone, city: city, position: position, period: period, quality: quality, education: education, experience: experience }
    else
      return { name: nil }
    end
  end
  
  
end
