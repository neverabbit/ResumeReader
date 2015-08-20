module ResumesHelper
  # get the desired information from original resume
  def resume_import(resume_file_path)
    
    #encoding: utf-8

    require 'nokogiri'

    # txt = File.open("dir/output.txt", "w+")
#     txt.close
    # Dir.foreach('.') do |d|
#       if d.match(/\.html/)
        # puts d
        f = File.open(resume_file_path)
        doc = Nokogiri::HTML(f)
        f.close
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
        # txt = File.open("dir/output.txt", "a+")
        # txt.puts(name_f, phone_f, city, period, position_f, quality_f, education_f)
        # txt.close
    
        # Dir.mkdir("dir")

      # end
   #  end
    
    
    
    return { name: name, phone: phone, city: city, position: position, period: period, quality: quality, education: education, experience: experience }
  end
    
end
