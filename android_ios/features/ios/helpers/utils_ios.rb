module LeeoApp
  module IOSHelpers

    def enter_text(field, text, options={:wait_for_keyboard => true})
      wait_for_element_exists(field, {:post_timeout => 0.4})
      touch(field)
      begin 
        fast_enter_text(text)
        #fast_text metod
      rescue
        clear_button = query(field, :_clearButton)
        if clear_button.count > 0
          touch(clear_button)
        end 
        wait_for_keyboard
        if (text.length >= 15)&(!!ENV['JENKINS'])
          text.each_char do |char|
          # defaults to 0.05 seconds
          # keyboard_enter_char(char, { :wait_after_char => 0.05 })
          keyboard_enter_char(char)
          end
        else
          keyboard_enter_text(text)
        end
      end
    end

    def custom_clear_text(field)
      wait_for_elements_exist(field, {:post_timeout => 0.4})
      touch(field)
      not_empty = query(field)[0]['text'].length > 0
      if not_empty
        3.downto(0) do
          clear_button = query(field, :_clearButton)
          if clear_button.count>0
            sleep 0.5
            touch(clear_button)
            break
          end
          sleep 0.5
        end
      end
    end

    def is_enabled?(element)
      element_exists("#{element} isEnabled:1")
    end

    def should_be_enabled(element)
      fail unless is_enabled?(element)
    end

    def should_be_disabled(element)
      fail if is_enabled?(element)
    end

    def is_selected?(element)
      element_exists("#{element} isSelected:1")
    end

    def should_be_selected(element)
      fail unless is_selected?(element)
    end

    def should_be_deselected(element)
      fail if is_selected?(element)
    end

    def timeout_msg(msg)
      timeout=$TIMEOUT.clone
      timeout[:timeout_message] = msg
      return timeout
    end

    def hide_keyboard_if_visible
      if keyboard_visible?
        query "textField isFirstResponder:1", :resignFirstResponder
        sleep 1
      end
    end

    def mailbox_password_reset(newpass)
      for i in (0...10)
        puts "Trying to receive mail..."
        count=check_mailbox($USER.email,$GMAIL_PASSWORD)
        if count>0
          puts "Received mail..."
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

  end
end

World(LeeoApp::IOSHelpers)