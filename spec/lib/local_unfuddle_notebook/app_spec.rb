require 'spec_helper'

module LocalUnfuddleNotebook
  describe App do
    it "has args" do
      app = App.new(:args => ['test'])
      app.args.should == ['test']
    end

    it "can execute the args" do
      app = App.new(:args => ['test'])
      app.should respond_to(:execute)
    end
  end
end
