require_relative '../app.rb'
require_relative '../environment.rb'

RSpec.describe DataHandler do

  describe "sanitize_data" do
    it "returns an array of hashes" do

      app = App.new
      test_array = app.sanitize_data(app.api_searcher("harry potter"))
      expect(test_array).to be_instance_of(Array)
      expect(test_array[0]).to be_instance_of(Hash)

    end
  end

  describe "sanitize_data" do
    it "returns an array of hashes, each hash has a key of :author" do

      app = App.new
      test_array = app.sanitize_data(app.api_searcher("harry potter"))
      expect(test_array[0]).to have_key(:author)

    end
  end

  describe "sanitize_data" do
    it "handles multiple authors" do

      app = App.new
      test_array = app.sanitize_data(app.api_searcher("freakonomics"))
      expect(test_array[0][:author]).to include(",")

    end
  end

  describe "handle_authors" do
    it "returns a hash with a key of :author and value of some string" do
      app = App.new
      response = app.api_searcher("freakonomics")
      hash = {}
      return_book = app.handle_authors(response["items"][0]["volumeInfo"], hash)
      expect(return_book[:author].length).to be > 0
    end
  end

end
