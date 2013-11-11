#encoding: utf-8
class ParserController < ApplicationController
  require 'net/http'
  
  def index
    
  end
  
  def mail_parse
    
  end
  
  def parse_mails
    $stdin = File.open("#{Rails.root}/mails/#{params[:input][:file]}", 'r')
    while(line = gets) do
      line = line.delete("\n")
      if User.where(mail: line).blank?
        User.create(mail: line)
      end
    end
  end
  
  def parsing
    http = Net::HTTP.new('e.mail.ru')
    path = '/cgi-bin/passremind'
    par = {}
    cntr = 0
    list = User.where("(question is null or question = '') and frozen_now<>1 and id > 7629")
    list_size = list.size.to_s
    list.each do |u|
      sleep(6)
      cntr+=1
      #sleep(90) if cntr % 150 == 0
      puts "Now id(#{u.id}): #{u.mail} proceed. #{cntr.to_s}/#{list_size}"
      data = 'action=login&lang=ru_RU&Username='+u.mail+'&Domain=mail.ru'
      source = Nokogiri::HTML(http.post(path, data, par).body)
      begin
        if source.css('.login1 tr td div')[0]['style'] =~ /.*color\:\#ccc.*/
          u.update_attribute(:frozen_now, true)
          frozen = true
        end
        source.css('.login1 tr td div').text =~ /.*:\n(.*)/
        question = $1
        if question.present?
          question.strip!
          puts "\n"+question+"\n\n"
        end
        u.update_attribute(:question, question) unless frozen
      rescue
        sleep(10)
        next
      end
    end
  end
end
