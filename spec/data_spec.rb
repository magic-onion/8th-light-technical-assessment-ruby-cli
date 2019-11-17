require_relative '../app.rb'
require_relative '../environment.rb'

RSpec.describe DataHandler do

  describe "sanitize_data" do
    it "returns an array" do
      app = App.new
      test_array = app.sanitize_data(app.api_searcher("harry potter"))
      expect(test_array.length).to be_instance_of(Array)

    end
  end

end
