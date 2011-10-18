require 'spec_helper'

module LocalUnfuddleNotebook
  describe Notebook do
    let :last_updated_at do
      Time.now
    end

    let :attributes do
      {
        :subdomain => 'hmsinc',
        :username => 'gsmendoza',
        :password => '12345678',
        :project_id => 15,
        :notebook_id => 11,
        :last_updated_at => last_updated_at,
        :protocol => 'https'
      }
    end

    describe "with_attributes(settings)" do
      it "should build a new notebook with the given settings" do
        notebook = Notebook.with_attributes(attributes)
        notebook.url.should == "https://hmsinc.unfuddle.com/api/v1/projects/15/notebooks/11"
        notebook.user.should == 'gsmendoza'
        notebook.password.should == '12345678'
        notebook.last_updated_at.should == last_updated_at
        notebook.protocol.should == 'https'
      end

      it "should set the protocol to http by default" do
        notebook = Notebook.with_attributes({})
        notebook.protocol.should == 'http'
      end
    end

    describe "pull" do
      it "should save the notebook pages in the local pages path" do
        Pow(Notebook.local_pages_path).should_not exist

        notebook = Notebook.with_attributes(attributes)

        stub_request(:get, notebook.url_with_basic_auth('pages/unique')).
          to_return(:body => Pow('spec/fixtures/webmock/unique_pages_with_single_page.xml').read)

        notebook.pull

        notebook.remote_pages.should have(1).page
        Pow(Notebook.local_pages_path).should exist
        Pow(Notebook.local_pages_path).files.should have(1).file
      end

      it "should clear the local pages page before downloading the pages from remote" do
        Pow(Notebook.local_pages_path).create_directory do
          Pow("1-title.yaml").create_file
        end
        Pow(Notebook.local_pages_path).files.should have(1).file

        notebook = Notebook.with_attributes(attributes)

        no_pages_in_response_body = <<-EOS
        <?xml version="1.0" encoding="UTF-8"?>
        <pages type="array">
        </pages>
        EOS

        stub_request(:get, notebook.url_with_basic_auth('pages/unique')).
          to_return(:body => no_pages_in_response_body)

        notebook.pull

        Pow(Notebook.local_pages_path).should_not exist
      end

      it "should set the last_updated_at time of the notebook to now" do
        time_now = Time.now
        Time.stub(:now).and_return(time_now)

        notebook = Notebook.with_attributes(attributes)
        notebook.last_updated_at = nil

        stub_request(:get, notebook.url_with_basic_auth('pages/unique')).
          to_return(:body => Pow('spec/fixtures/webmock/unique_pages_with_single_page.xml').read)

        notebook.pull
        notebook.last_updated_at.should == time_now
      end

      it "should save the local attributes of the notebook" do
        time_now = Time.now
        Time.stub(:now).and_return(time_now)

        notebook = Notebook.with_attributes(attributes)

        stub_request(:get, notebook.url_with_basic_auth('pages/unique')).
          to_return(:body => Pow('spec/fixtures/webmock/unique_pages_with_single_page.xml').read)

        notebook.pull

        local_attributes = {
          :subdomain => 'hmsinc',
          :username => 'gsmendoza',
          :password => '12345678',
          :project_id => 15,
          :notebook_id => 11,
          :last_updated_at => time_now,
          :protocol => 'https'
        }

        Pow(Notebook.attributes_path).should be_a_file
        Pow(Notebook.attributes_path).read.should == local_attributes.to_yaml
      end
    end

    describe "remote_pages" do
      it "should be the pages of the notebook from unfuddle" do
        notebook = Notebook.with_attributes(attributes)

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

    describe "saved_attributes" do
      it "should get the connection settings from the local connection settings file" do
        Pow(Notebook.attributes_path).should_not exist
        Notebook.saved_attributes.should be_nil

        content = <<-EOS
        --- !map:Thor::CoreExt::HashWithIndifferentAccess
        notebook_id: "11"
        project_id: "15"
        username: gsmendoza
        subdomain: hmsinc
        password: 12345678
        EOS

        Pow(Notebook.attributes_path).write(content)

        settings = Notebook.saved_attributes
        settings[:username].should == 'gsmendoza'
      end
    end

    describe "url_with_basic_auth(suburl)" do
      it "should be add the user and password to the suburl" do
        notebook = Notebook.with_attributes(attributes)

        notebook.url_with_basic_auth('pages/unique').should ==
          "https://gsmendoza:12345678@hmsinc.unfuddle.com/api/v1/projects/15/notebooks/11/pages/unique"
      end
    end

    describe "local_attributes" do
      it "should be the attributes of the notebook intended for saving" do
        notebook = Notebook.with_attributes(attributes)
        notebook.last_updated_at = time_now = Time.now

        notebook.local_attributes.should == {
          :subdomain => 'hmsinc',
          :username => 'gsmendoza',
          :password => '12345678',
          :project_id => 15,
          :notebook_id => 11,
          :last_updated_at => time_now,
          :protocol => 'https'
        }
      end
    end

    describe "subdomain" do
      it "should come from the url" do
        notebook = Notebook.new("http://sub.domain.unfuddle.com")
        notebook.subdomain.should == "sub.domain"
      end
    end

    describe "project_id" do
      it "should come from the url" do
        notebook = Notebook.new("http://hmsinc.unfuddle.com/api/v1/projects/15/notebooks/11/pages/unique")
        notebook.project_id.should == 15
      end
    end

    describe "notebook_id" do
      it "should come from the url" do
        notebook = Notebook.new("http://hmsinc.unfuddle.com/api/v1/projects/15/notebooks/11/pages/unique")
        notebook.notebook_id.should == 11
      end
    end

    describe "local_pages" do
      it "should be the pages stored locally" do

        attributes = {
          :id => 1,
          :title => 'This is a title',
          :body => 'This is a body',
          :message => 'This is a message'
        }
        (Pow(Notebook.local_pages_path) / "1-this-is-a-title.yaml").write attributes.to_yaml

        notebook = Notebook.new("url")
        local_pages = notebook.local_pages
        local_pages.should have(1).page

        local_page = local_pages.first

        local_page.id.should == 1
        local_page.notebook.should == notebook
        local_page.local_file.name(true).should == "1-this-is-a-title.yaml"
        local_page.title.should == 'This is a title'
      end
    end

    describe "push" do
      it "should upload a changed page to unfuddle" do
        page = Page.new
        page.should_receive(:changed?).and_return(true)
        page.should_receive(:message=).with("message")
        page.should_receive(:push)

        notebook = Notebook.with_attributes(attributes)
        notebook.should_receive(:local_pages).and_return([page])

        notebook.push 'message'
      end

      it "should update and save the last_updated_at timestamp" do
        Pow(Notebook.local_pages_path).create_directory

        time_now = Time.now
        Time.stub(:now).and_return(time_now)

        notebook = Notebook.with_attributes(attributes)
        notebook.push 'message'
        notebook.last_updated_at.should == time_now

        YAML::load(Pow(Notebook.attributes_path).read)[:last_updated_at].should == time_now
      end
    end

    describe "protocol" do
      it "should come from the url" do
        notebook = Notebook.new("https://hmsinc.unfuddle.com")
        notebook.protocol.should == 'https'
      end
    end
  end
end

