module DataHandler
  def sanitize_data(parsed_response) #takes in parsed JSON, outputs a stable hash
    sanitized_data = []
    if (parsed_response["totalItems"] > 5)
      i = 0
      until i === 5 do
        new_book = {}
        new_book[:title] = parsed_response["items"][i]["volumeInfo"]["title"]
        new_book[:publisher] = parsed_response["items"][i]["volumeInfo"]["publisher"]
        clean_book = handle_authors(parsed_response["items"][i]["volumeInfo"], new_book)
        if (!clean_book[:publisher])
          clean_book[:publisher]  = "Not Found"
        end
        sanitized_data.push(clean_book)
        i += 1
      end

    elsif (parsed_response["totalItems"] <= 5)
      i = 0
      until i === parsed_response["totalItems"].length do
        new_book = {}
        new_book[:title] = parsed_response["items"][i]["volumeInfo"]["title"]
        new_book[:publisher] = parsed_response["items"][0]["volumeInfo"]["publisher"]
        clean_book = handle_authors(parsed_response["items"][i]["volumeInfo"], new_book)
        if (!clean_book[:publisher])
          clean_book[:publisher]  = "Not Found"
        end
        sanitized_data.push(clean_book)
      end
    end
    sanitized_data
  end

  def handle_authors(volume_hash, book) #helper method to avoid overly clunky santitizer
    if (!volume_hash["authors"])
      book[:author] = "Not Found"
    elsif (volume_hash["authors"].length > 1)
      author_string = ""
      volume_hash["authors"].each {|author| author_string += ", " + author}
      author_string = author_string[2..-1]
      book[:author] = author_string
    else
      book[:author] = volume_hash["authors"][0]
    end
    book
  end

end
