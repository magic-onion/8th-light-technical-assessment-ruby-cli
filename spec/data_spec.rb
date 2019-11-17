require_relative '../app.rb'
require_relative '../environment.rb'

RSpec.describe DataHandler do

  describe "data" do
    it "returns a hash" do
      app = App.new
      puts app.sanitize_data(app.api_searcher("harry potter"))
      expect(app.tester).to eq(3)
    end
  end

end
