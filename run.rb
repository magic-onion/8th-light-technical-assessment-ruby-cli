class App

  def initialize
  end

  def launch
    puts "hello you are running me"
  end

  def run_list
    input = ''
    while input
      puts "Please enter a command", ""
      input = gets.chomp
      case input
      when "hi" then puts "thanks"
        break
      else puts "sorry, I'm not sure what that means"
      end
    end
    run_list
  end

end

app = App.new
app.launch
app.run_list
