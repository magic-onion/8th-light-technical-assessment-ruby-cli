require_relative './environment'
require 'rest-client'
require 'json'

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
      when "search books" then search_menu
      when "exit" then exit
        break
      else puts "sorry, I'm not sure what that means"
      end
    end
    run_list
  end

  def search_menu
    puts "type in a query to search the Google Books Api"
    input = gets.chomp
    searcher(input)
    puts "done searching"
  end

  def searcher(input) #handles the search
    url = "https://www.googleapis.com/books/v1/volumes?q=#{input}+intitle&key=#{API_KEY}"
    response = RestClient.get(url)
    hash = JSON.parse(response)
    (response.code === 200 && hash["totalItems"] != 0)  ? sanitizer(hash) : (puts "no results")

  end


  def sanitizer(hash) #only cleans the data
    sanitized_data = []
    if (hash["totalItems"] != 0)
      if (hash["totalItems"] > 5)
        i = 0
        until i === 5 do
          new_book = {}
          new_book[:title] = hash["items"][i]["volumeInfo"]["title"]
          new_book[:author] = hash["items"][i]["volumeInfo"]["title"]["authors"]
          new_book[:publisher] = hash["items"][0]["volumeInfo"]["publisher"]
          new_book.each {|key, value| !value ? new_book[key] = "Not Found" : new_book[key] = value}
          sanitized_data.push(new_book)
          i += 1
        end
      elsif (hash["totalItems"] <= 5)
        i = 0
        until i === hash["totalItems"].length do
          new_book = {}
          new_book[:title] = hash["items"][i]["volumeInfo"]["title"]
          new_book[:author] = hash["items"][i]["volumeInfo"]["title"]["authors"]
          new_book[:publisher] = hash["items"][0]["volumeInfo"]["publisher"]
          new_book.each {|key, value| !value ? new_book[key] = "Not Found" : new_book[key] = value}
          sanitized_data.push(new_book)
        end
        puts "length of array is: #{hash["items"].length}"
      end
      puts "length of array is: #{sanitized_data.length}"
      puts sanitized_data
    else
      puts "no results found"
    end

    def generate_output(array)

    end




    def sanitizer(hash)

    end
  end




  def exit
    puts "now exiting gracefully"
    exit!
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
# Each item in the list should include the book's author, title, and publishing company.
# A user should be able to select a book from the five displayed to save to a “Reading List”
# View a “Reading List” with all the books the user has selected from their queries -- this is a local reading list and not tied to Google Books’s account features.
# Reading list displays five at a time with next and back commands?
# Read me
# Short welcome prompts
# next/back
# Error handling
