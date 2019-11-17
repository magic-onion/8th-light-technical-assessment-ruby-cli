require_relative '../app.rb'
require_relative '../environment.rb'

RSpec.describe DataHandler do

  describe "sanitize_data" do
    it "returns an array" do

      app = App.new
      test_array = app.sanitize_data(app.api_searcher("harry potter"))
      expect(test_array).to be_instance_of(Array)

    end
  end

  describe "sanitize_data" do
    it "returns a has with a key of :author" do

      app = App.new
      test_array = app.sanitize_data(app.api_searcher("freakonomics"))
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

end
