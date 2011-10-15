require 'spec_helper'

module LocalUnfuddleNotebook
  describe App do
    describe "parse_args(args)" do
      it "should have the help option if there are no args" do
        app = App.new
        slop = app.parse_args([])
        slop.options.should have(1).option
        option = slop.options.first
        option.long_flag.should == 'help'
      end

      it "should set the command and options on checkout" do
        app = App.new
        app.parse_args(['checkout',
          '--subdomain=hmsinc',
          '--username=gsmendoza',
          '--password=********',
          '--project_id=15',
          '--notebook_id=11'
        ])

        app.command.should == :checkout
        app.options[:subdomain].should == 'hmsinc'
      end
    end

    describe "execute" do
      xit "can checkout the notebook" do
        app = App.new(:args => ['checkout',
          '--subdomain=hmsinc',
          '--username=gsmendoza',
          '--password=********',
          '--project_id=15',
          '--notebook_id=11'
        ])
      end
    end
  end
end
