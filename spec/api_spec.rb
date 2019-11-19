require_relative '../app.rb'
require_relative '../environment.rb'

RSpec.describe ApiAdapter do

  before do
    @app= App.new
  end

  describe "api_search_by_author" do
    it "returns a parsed response for author search" do

      test_response = @app.api_search_by_author("Stephen King")
      expect(test_response).to be_instance_of(Hash)

    end
  end


end
