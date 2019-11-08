module DataHandler
  def sanitize_data(hash) #only cleans the data
    sanitized_data = []
    if (hash["totalItems"] > 5)
      i = 0
      until i === 5 do
        new_book = {}
        new_book[:title] = hash["items"][i]["volumeInfo"]["title"]
        new_book[:publisher] = hash["items"][i]["volumeInfo"]["publisher"]
        clean_book = handle_authors(hash["items"][i]["volumeInfo"], new_book)
        if (!clean_book[:publisher])
          clean_book[:publisher]  = "Not Found"
        end
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
    end
    sanitized_data
  end

  def handle_authors(volume_hash, book)
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
