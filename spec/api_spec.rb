require_relative '../app.rb'
require_relative '../environment.rb'

RSpec.describe ApiAdapter do

  before do
    @app= App.new
  end

  #these tests were written before search_by_author method was written
  describe "api_search_by_author" do
    it "returns a parsed response for author search" do

      test_response = @app.api_search_by_author("Stephen King")
      expect(test_response).to be_instance_of(Hash)

    end
  end

  describe "api_search_by_author" do
    it "handles unexpected queries" do
      test_response = @app.api_search_by_author("2p39y230rhjoewhjf9p8y59208340-129!@%^&*()}")
      expect(test_response).to be_instance_of(Hash)

    end
  end


end
