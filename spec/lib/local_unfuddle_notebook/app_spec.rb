require 'spec_helper'

module LocalUnfuddleNotebook
  describe App do
    it "has args" do
      app = App.new(:args => ['test'])
      app.args.should == ['test']
    end

    describe "parse_args" do
      it "should have the help option if there are no args" do
        app = App.new(:args => [])
        app.parse_args.options.should have(1).option
        option = app.parse_args.options.first
        option.long_flag.should == 'help'
      end

      it "should set the command and options on checkout" do
        app = App.new(:args => ['checkout',
          '--subdomain=hmsinc',
          '--username=gsmendoza',
          '--password=********',
          '--project_id=15',
          '--notebook_id=11'
        ])

        app.parse_args

        app.command.should == :checkout
        app.options[:subdomain].should == 'hmsinc'
      end
    end
  end
end
