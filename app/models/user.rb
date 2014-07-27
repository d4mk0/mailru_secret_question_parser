class User < ActiveRecord::Base
  validates :mail, presence: true, uniqueness: true
  attr_accessible :mail, :is_phone_assigned, :response_status, :question, :password
  
  scope :unsuccessfulls, -> {where 'response_status != 200 OR response_status is null'}
  scope :without_password, -> {where password: nil}
  scope :processed, -> {where response_status: 200}
  scope :by_question, ->(question) {where question: question}
  
  def self.get_uniq_questions
    without_password.processed.group(:question).order('count_all desc').count.to_yaml
  end
  
  def self.save_questions(file = 'questions.txt')
    File.open("#{Rails.root}/#{file}", "w") {|file| file.write get_uniq_questions }
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
  
  def set_pasword(password = 'qweqwe456qwe')
    update_attributes password: password
  end
end

