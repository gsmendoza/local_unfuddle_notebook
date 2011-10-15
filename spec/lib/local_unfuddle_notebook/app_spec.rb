require 'spec_helper'

module LocalUnfuddleNotebook
  describe App do
    let :connection_settings do
      {
        :subdomain => 'hmsinc',
        :username => 'gsmendoza',
        :password => '12345678',
        :project_id => 15,
        :notebook_id => 11
      }
    end

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

    describe "init" do
      it "should save the connection settings of the notebook" do
        Pow(App.config_path).should_not exist

        app = App.new(:command => 'checkout', :options => connection_settings)
        app.init

        Pow(App.config_path).should be_a_file
        Pow(App.config_path).read.should == connection_settings.to_yaml
      end
    end

    describe "notebook" do
      it "should be get its url, username and password from the options" do
        app = App.new(:command => 'checkout', :options => connection_settings)
        notebook = app.notebook
        notebook.url.should == app.notebook_url
        notebook.user.should == 'gsmendoza'
        notebook.password.should == '12345678'
      end
    end

    describe "notebook_url" do
      it "should get the subdomain, project id and notebook id from the options" do
        app = App.new(:command => 'checkout', :options => connection_settings)
        app.notebook_url.should == 'http://hmsinc.unfuddle.com/api/v1/projects/15/notebooks/11'
      end
    end
  end
end
