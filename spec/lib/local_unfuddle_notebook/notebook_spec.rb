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

    describe "pull" do
      it "should save the notebook pages in the local pages path" do
        Pow(Notebook.local_pages_path).should_not exist

        notebook = Notebook.with_connection_settings(connection_settings)

        stub_request(:get, notebook.url_with_basic_auth('pages/unique')).
          to_return(:body => Pow('spec/fixtures/webmock/unique_pages_with_single_page.xml').read)

        notebook.pull

        notebook.remote_pages.should have(1).page
        Pow(Notebook.local_pages_path).should exist
        Pow(Notebook.local_pages_path).files.should have(1).file
      end
    end

    describe "remote_pages" do
      it "should be the pages of the notebook from unfuddle" do
        notebook = Notebook.with_connection_settings(connection_settings)

        response_body = <<-EOS
        <?xml version="1.0" encoding="UTF-8"?>
        <pages type="array">
         <page>
            <author-id type="integer">23</author-id>
            <body>Body
        # Head
            code
        </body>
            <body-format>markdown</body-format>
            <id type="integer">268</id>
            <message>This is a message.</message>
            <message-format>markdown</message-format>
            <notebook-id type="integer">11</notebook-id>
            <number type="integer">8</number>
            <title>This is the title.</title>
            <version type="integer">12</version>
            <created-at>2011-10-12T08:29:21Z</created-at>
            <updated-at>2011-10-12T08:29:21Z</updated-at>
          </page>
        </pages>
        EOS

        stub_request(:get, notebook.url_with_basic_auth('pages/unique')).
          to_return(:body => response_body)

        remote_pages = notebook.remote_pages
        remote_pages.should have(1).page

        page = remote_pages[0]
        page.id.should == 268
        page.title.should == 'This is the title.'
        page.notebook.should == notebook
      end
    end

    describe "saved_connection_settings" do
      it "should get the connection settings from the local connection settings file" do
        Pow(Notebook.connection_settings_path).should_not exist
        Notebook.saved_connection_settings.should be_nil

        content = <<-EOS
        --- !map:Thor::CoreExt::HashWithIndifferentAccess
        notebook_id: "11"
        project_id: "15"
        username: gsmendoza
        subdomain: hmsinc
        password: 12345678
        EOS

        Pow(Notebook.connection_settings_path).write(content)

        settings = Notebook.saved_connection_settings
        settings[:username].should == 'gsmendoza'
      end
    end

    describe "url_with_basic_auth(suburl)" do
      it "should be add the user and password to the suburl" do
        notebook = Notebook.with_connection_settings(connection_settings)

        notebook.url_with_basic_auth('pages/unique').should ==
          "http://gsmendoza:12345678@hmsinc.unfuddle.com/api/v1/projects/15/notebooks/11/pages/unique"
      end
    end
  end
end

