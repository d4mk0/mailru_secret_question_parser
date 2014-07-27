class Import
  DOMAINS = ['mail.ru', 'inbox.ru', 'bk.ru', 'list.ru']
  
  def from_file(file)
    file.read.each_line {|line|
      p 'line'
      p line
      if line =~ /avt.imgsmail.ru\/([^\/]*)\/([^\/]*)/ && DOMAINS.include?($1) && !User.exists?(mail: $2+'@'+$1)
        User.create mail: $2+'@'+$1
      end
    }
  end
end