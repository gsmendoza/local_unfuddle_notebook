require 'spec_helper'

module LocalUnfuddleNotebook
  describe App do
    it "has args" do
      app = App.new(:args => ['test'])
      app.args.should == ['test']
    end

    describe "slop" do
      it "should be empty if there are no args" do
        app = App.new(:args => [])
        app.slop.options.should have(1).option
        option = app.slop.options.first
        option.long_flag.should == 'help'
      end
    end
  end
end
