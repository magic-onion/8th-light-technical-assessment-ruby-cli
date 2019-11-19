module ApiAdapter

  def api_searcher(input) #handles the search, only via title, light error handling
    url = "https://www.googleapis.com/books/v1/volumes?q=#{input}+intitle&key=#{API_KEY}"
    response = RestClient.get(url)
    parsed_response = JSON.parse(response)
    (response.code === 200 && parsed_response["totalItems"] != 0)  ? parsed_response : (puts "\nno results found, please try again \n")
  end

  def api_search_by_author(input)
    url = "https://www.googleapis.com/books/v1/volumes?q=#{input}+inauthor&key=#{API_KEY}"
    response = RestClient.get(url)
    parsed_response = JSON.parse(response)
    parsed_response
  end


end
