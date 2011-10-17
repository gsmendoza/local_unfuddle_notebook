require 'spec_helper'

module LocalUnfuddleNotebook
  describe Notebook do
    let :connection_settings do
      {
        :subdomain => 'hmsinc',
        :username => 'gsmendoza',
        :password => '12345678',
        :project_id => 15,
        :notebook_id => 11
      }
    end

    describe "init" do
      it "should save the connection settings of the notebook" do
        Pow(Notebook.connection_settings_path).should_not exist

        notebook = Notebook.init(connection_settings)
        notebook.should be_a(Notebook)

        Pow(Notebook.connection_settings_path).should be_a_file
        Pow(Notebook.connection_settings_path).read.should == connection_settings.to_yaml
      end
    end

    describe "with_connection_settings(settings)" do
      it "should build a new notebook with the given settings" do
        notebook = Notebook.with_connection_settings(connection_settings)
        notebook.url.should == "http://hmsinc.unfuddle.com/api/v1/projects/15/notebooks/11"
        notebook.user.should == 'gsmendoza'
        notebook.password.should == '12345678'
      end
    end
  end
end

