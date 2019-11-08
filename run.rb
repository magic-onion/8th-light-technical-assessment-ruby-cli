require_relative './environment'

require 'rest-client'
require 'json'
require 'pstore'

class App

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
    puts "hello you are running me"
  end

  def run_list
    input = ''
    while input
      puts "Please enter a command", ""
      input = gets.chomp
      case input
      when "search books" then search_menu
      when "view reading list" then view_reading_list
      when "NUKE MY LIST" then clear_pstore_data
      when "exit" then exit
        break
      else puts "sorry, I'm not sure what that means"
      end
    end
    run_list
  end



  def search_menu
    puts "Type in a query to search the Google Books Api by Publication Title \n"
    input = gets.chomp
    searcher(input)
    puts "done searching \n"
    reading_list_prompt
  end

  def reading_list_prompt
    puts "\nSelect a number (1-5) to add to your reading list, or enter `go back` to reach the main menu"
    input = gets.chomp
    handle_save(input)
  end

  def handle_save(input)
    selection = input.to_i - 1
    @store.transaction do
      @store[:saved_books].push(@search_results[selection])
      puts @store[:saved_books]
      @store.commit
    end
  end

  def searcher(input) #handles the search
    url = "https://www.googleapis.com/books/v1/volumes?q=#{input}+intitle&key=#{API_KEY}"
    response = RestClient.get(url)
    hash = JSON.parse(response)
    (response.code === 200 && hash["totalItems"] != 0)  ? sanitizer(hash) : (puts "no results found, please try again \n")

  end





  def generate_output(array)
    i = 1
    array.each do |hash|
      puts "\n #{i}. Title: #{hash[:title]} ||| Author: #{hash[:author]} ||| Publisher: #{hash[:publisher] }\n \n"
      i += 1
    end

  end

  def view_reading_list
    @store.transaction do
      puts "in transaction"
      puts @store[:saved_books]
    end
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




  def sanitizer(hash) #only cleans the data
    sanitized_data = []
    if (hash["totalItems"] > 5)
      i = 0
      until i === 5 do
        new_book = {}
        new_book[:title] = hash["items"][i]["volumeInfo"]["title"]
        new_book[:publisher] = hash["items"][i]["volumeInfo"]["publisher"]
        clean_book = handle_authors(hash["items"][i]["volumeInfo"], new_book)
        sanitized_data.push(clean_book)
        i += 1
      end

    elsif (hash["totalItems"] <= 5)
      i = 0
      until i === hash["totalItems"].length do
        new_book = {}
        new_book[:title] = hash["items"][i]["volumeInfo"]["title"]
        new_book[:publisher] = hash["items"][0]["volumeInfo"]["publisher"]
        clean_book = handle_authors(hash["items"][i]["volumeInfo"], new_book)
        sanitized_data.push(new_book)
      end
      puts "length of array is: #{hash["items"].length} \n"
    end
    puts "length of array is: #{sanitized_data.length} \n"
    @search_results = sanitized_data
    generate_output(sanitized_data)
  end

  def handle_authors(authors_hash, book)
    if (!authors_hash["authors"])
      book[:author] = "Not Found"
    elsif (authors_hash["authors"].length > 1)
      author_string = ""
      authors_hash["authors"].each {|author| author_string += ", " + author}
      author_string = author_string[2..-1]
      book[:author] =  author_string
    else
      book[:author] = authors_hash["authors"][0]
    end
    book
  end


















end

app = App.new
app.launch
app.run_list


# query format
# a mehtod to make the hash
# a method that takes in the has and displays results

# a test???


# Type in a query and display a list of 5 books matching that query.
  #display results nicely

# Each item in the list should include the book's author, title, and publishing company.
#yup

# A user should be able to select a book from the five displayed to save to a “Reading List”
# View a “Reading List” with all the books the user has selected from their queries -- this is a local reading list and not tied to Google Books’s account features.
# Reading list displays five at a time with next and back commands?
# Read me
# Short welcome prompts
# next/back
# Error handling

#write a method that takes in an array of output, allows the user to select one to add  to reading list


# two cases values are nil and authors is an array
