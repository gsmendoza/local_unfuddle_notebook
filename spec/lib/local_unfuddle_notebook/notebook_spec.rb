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
        Pow(Notebook.config_path).should_not exist

        Notebook.init connection_settings

        Pow(Notebook.config_path).should be_a_file
        Pow(Notebook.config_path).read.should == connection_settings.to_yaml
      end
    end
  end
end

