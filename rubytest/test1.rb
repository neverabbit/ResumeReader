#coding: utf-8

require 'nokogiri'

txt = File.open("dir/output.txt", "w+")
txt.close
Dir.foreach('.') do |d|
  if d.match(/\.html/)
    puts d
    f = File.open(d)
    doc = Nokogiri::HTML(f)
    f.close
    name = doc.css(".main-title-fl").first.content
    
    
    name_f = name.gsub(' ','')
    #puts name_f
    # puts doc.inspect
    phone = doc.css(".main-title-fr").first.content
    phone_f = phone.gsub(/\D/,'')
    #puts phone_f
    
    summary = doc.css(".summary-top span").first.content
    #puts '\u00a0\u7537'.encode
    
    #puts "%04x" % summary.unpack("U*")[0]
    
    period = summary.match(/\S+工作经验/).to_s.gsub(/\u00a0/, ' ').match(/\S+$/).to_s
    #puts period
    
    #puts doc.css(".summary-top").first.content
    city = doc.css(".summary-top").first.content.match(/现居住地\S+/).to_s.gsub(' ','')[5..-1]
    # puts city_r.inspect
    # city = city_r.gsub(' ','')[5..-1]
    #puts city
    
    if position_r = doc.css(".resume-previes-all h5")
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
    txt = File.open("dir/output.txt", "a+")
    txt.puts(name_f, phone_f, city, period, position_f, quality_f, education_f)
    txt.close
    
    # Dir.mkdir("dir")

  end
end

# position_r.each do |p|
#   p.content.match()
#   puts p.content
# end
#puts position_r