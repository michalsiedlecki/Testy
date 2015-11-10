begin
  require 'CGI'
  require 'gmail'
rescue LoadError
  puts "cannot load gem gmail"
end

Leeo_email="postmaster@test-mail.leeo.com"
Sub="Leeo Password Reset Request"

def html2text(html)
  text = html.to_s.
  gsub(/(&nbsp;|\n|\s)+/im, ' ').squeeze(' ').strip.gsub(/<([^\s]+)[^>]*(src|href)=\s*(.?)([^>\s]*)\3[^>]*>\4<\/\1>/i,'\4')
  links = []
  linkregex = /<[^>]*(src|href)=\s*(.?)([^>\s]*)\2[^>]*>\s*/i
  while linkregex.match(text)
    links << $~[3]
    text.sub!(linkregex, "[#{links.size}]")
  end
  text = CGI.unescapeHTML(
  text.
  gsub(/<(script|style)[^>]*>.*<\/\1>/im, '').
  gsub(/<!--.*-->/m, '').
  gsub(/<hr(| [^>]*)>/i, "___\n").
  gsub(/<li(| [^>]*)>/i, "\n* ").
  gsub(/<blockquote(| [^>]*)>/i, '> ').
  gsub(/<(br)(| [^>]*)>/i, "\n").
  gsub(/<(\/h[\d]+|p)(| [^>]*)>/i, "\n\n").
  gsub(/<[^>]*>/, '')
  ).lstrip.gsub(/\n[ ]+/, "\n") + "\n"

  for i in (0...links.size).to_a
    text = text + "\n  [#{i+1}] <#{CGI.unescapeHTML(links[i])}>" unless
    links[i].nil?
  end
  links = nil
  text
end

def clean_mailbox(box=nil,pass=nil)
  if (box == nil || pass == nil)
    box=$USER.email
    pass=$GMAIL_PASSWORD
  end
  if box.include?"+"
    parent_box=box.gsub(/[0-9+]/,'')
  end 
  gmail = Gmail.connect("#{parent_box}","#{pass}")
  count=gmail.inbox.count(:unread,:to => "#{box}", :from => "#{Leeo_email}", :subject => "#{Sub}")
  if count >0
    puts "#{count} #{Sub} emails in the box will be marked as read"
    gmail.inbox.find(:unread, :from => "#{Leeo_email}", :subject => "#{Sub}").each do |email|
      email.read!
    end
  else
    puts "Mailbox #{box} has no unread messages for #{Sub}"
  end
  gmail.logout
end

def check_mailbox(box,pass)
  if box.include?"+"
    parent_box=box.gsub(/[0-9+]/,'')
  end 
  gmail = Gmail.connect("#{parent_box}","#{pass}")
  out=gmail.logged_in?
  if out
    num=gmail.inbox.count(:unread,:to => "#{box}", :from => "#{Leeo_email}", :subject => "#{Sub}")
    gmail.logout
    return num
  else
    fail "Not logged in mailbox"
  end
end

def check_message(box,pass)
  if box.include?"+"
    parent_box=box.gsub(/[0-9+]/,'')
  end 
  gmail = Gmail.connect("#{parent_box}","#{pass}")
  gmail.inbox.emails(:unread,:to => "#{box}", :from => "#{Leeo_email}", :subject => "#{Sub}").each do |email|
    backend="#{$API_SERVER}".gsub(/(https|\/|api|:)/,'')
    msg=email.html_part.body.decoded
    plain_text = html2text(msg)
    ar=plain_text.split(" ")
    num=ar.length
    for i in (0...num)
      if ar[i].include? "#{backend}"+":443/password_reset"
        link=ar[i]
        link.gsub!(/[^0-9A-Za-z?&=:,-]/, '')
        hash = {}
        link = link.split('?')[1]
        link.split('&').each do |pair|
          key,value = pair.split('=')
          hash[key] = value
        end
      end
    end
    if hash==nil
      fail "Data not retrieved"
    else
      return hash
    end
  end
end

def mailbox_password_reset(newpass)
  for i in (0...10)
    puts "Trying to recieve mail..."
    count=check_mailbox($USER.email,$GMAIL_PASSWORD)
    if count>0
      puts "Recieved mail..."
      break
    end
    sleep(20)
  end
  if count==0
    puts "The are no Reset Password message on the mailbox"
    fail
  else
    hash=check_message($USER.email,$GMAIL_PASSWORD)
    if hash
      reset_gmail_password(hash["userid"].to_i,hash["creationtime"].to_i,hash["sig"],newpass)
    else
      puts "Email message not recovered"
      fail
    end
  end
end

def reset_gmail_password(user_id, creation_time, signature, password)
  path = "/users/#{user_id}/reset_password"
  param = Curl::PostField.content('id', user_id), Curl::PostField.content('creation_time' , creation_time),
      Curl::PostField.content('sig' , signature),
      Curl::PostField.content('password' , password)
  response, output = api_post(path, param)
  if response == 201
    puts "Password has been reset for user with id #{user_id}"
    return output
  else
    puts "Password has not been reset for user with id #{user_id}"
    puts param, output
  end
end

def is_a_valid_email?(email)
  email_regex = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  (email =~ email_regex)
end

