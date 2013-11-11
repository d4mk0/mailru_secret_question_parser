#encoding: utf-8
class User < ActiveRecord::Base
  validates :mail, presence: true, uniqueness: true
  attr_accessible :mail
  
  
  def self.get_bad_questions
    questions = []
    file = File.open("#{Rails.root}/mails/bad_questions.txt").read
    file.gsub!(/\r\n?/, "\n")
    file.each_line do |question|
      question.delete!("\n")
      questions << question
    end
    questions
  end
    
  def self.mail_question_stripping
    all.each do |u|
      changed = false
      if u.mail.include?("\n")
        u.mail = u.mail.delete("\n")
        changed = true
      end
      if u.question.present? && u.question != u.question.strip
        u.question = u.question.strip
        changed = true
      end
      u.save if changed
    end
  end
  
  def self.remove_duplicates
    User.all.each do |u|
      u.mail
      current = User.where(:mail => u.mail)
      if current.size != 1
        if current.first.question.present?
          current.last.destroy 
        else
          if current.second.question.present?
            current.first.destroy
          else
            current.last.destroy
          end
        end
      end
    end
  end
  
  def self.good_to_file
    File.open("#{Rails.root}/mails/questions1.txt", 'w') do |file|
      query = ""
      bad_questions = User.get_bad_questions
      bad_questions.each do |q|
        query+= "question <> '#{q}'"
        query+= " and " if q != bad_questions[bad_questions.size-1]
      end
      where("question is not null and #{query} and password is null").each do |u|
        file.write u.mail+"  "+u.question+"\n"
      end
    end
  end
end
