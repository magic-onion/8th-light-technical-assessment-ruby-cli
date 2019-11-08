require_relative './modules/api_adapter'
require_relative './modules/data_handler'


class App

  include ApiAdapter
  include DataHandler

  def initialize()
    @search_results
    @search_result_strings
    @store = PStore.new('store.pstore')
    @store.transaction do
      @store.abort if @store[:saved_books].length > 0
      @store[:saved_books] = []
      @store.commit
    end
  end

  def launch
    puts "Welcome!"
    app_menu
  end


  def menu_prompt
    puts "\nPlease Enter one of the Commands Listed Here"
    puts "\nenter 'search books' to query the Google Books API"
    puts "\nenter 'view reading list' to view your reading list"
    puts "\nenter 'exit' to exit this session"
  end

  def app_menu
    menu_prompt
    input = ''
    while input
      puts "\nPlease enter a command", ""
      input = gets.chomp
      case input
      when "search books" then search_menu
      when "view reading list" then view_reading_list
      when "NUKE MY LIST" then clear_pstore_data
      when "exit" then exit
        break
    else
      puts "\nsorry, I'm not sure what that means"
      menu_prompt
      end
    end
  end

  def search_menu
    puts "Type in a query to search the Google Books Api by Publication Title \n"
    input = gets.chomp
    puts "\n Now Searching..."
    hash = api_searcher(input)
    if (!hash)
      search_menu
    else
      system("clear")
      clean_data = sanitize_data(hash)
      @search_results = clean_data
      puts "\n Done Searching! Here are Your Results\n"
      generate_output(@search_results)
      reading_list_prompt
    end
  end

  def reading_list_prompt
    input = ""
    prompt = "\nSelect a number (1-5) to add to your reading list, or enter `go back` to reach the main menu"
    while input
      puts prompt
      input = gets.chomp
      if ((1..5).include?(input.to_i)) then handle_save(input)
      else
        case input
        when "go back" then app_menu
        when "exit" then exit
        else
          system("clear")
          puts "\nApologies, that input is not recognized"
          generate_output(@search_results)
        end
      end
    end
  end

  def handle_save(input)
    selection = input.to_i - 1
    @store.transaction do
      @store[:saved_books].push(@search_results[selection])
      @store.commit
    end
    puts "\n Saved to your list!"
    system("clear")
    generate_output(@search_results)
    reading_list_prompt
  end

  def generate_output(array)
    i = 1
    array.each do |hash|
      puts "\n #{i}. Title: #{hash[:title]} ||| Author: #{hash[:author]} ||| Publisher: #{hash[:publisher] }\n \n"
      i += 1
    end

  end

  def view_reading_list
    system("clear")
    @store.transaction do
      puts "\n your Current Reading List \n"
      generate_output(@store[:saved_books])
      puts "\n"
    end
    menu_prompt
  end


  def exit
    puts "now exiting gracefully"
    exit!
  end

  def clear_pstore_data
    @store.transaction do
      @store[:saved_books] = []
      @store.commit
    end
  end

  def search_results_setter(array)
    @search_results = array
  end

  def clear_search_results
    @search_results = []
  end


end


# add comments
# clean up