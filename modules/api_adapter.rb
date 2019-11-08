module ApiAdapter

  def api_searcher(input) #handles the search
    url = "https://www.googleapis.com/books/v1/volumes?q=#{input}+intitle&key=#{API_KEY}"
    response = RestClient.get(url)
    hash = JSON.parse(response)
    (response.code === 200 && hash["totalItems"] != 0)  ? hash : (puts "\nno results found, please try again \n")
  end


end
