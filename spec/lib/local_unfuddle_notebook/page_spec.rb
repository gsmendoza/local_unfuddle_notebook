require 'spec_helper'

module LocalUnfuddleNotebook
  describe Page do
    describe "save" do
      it "should save the page in the local pages path" do
        Pow(Notebook.local_pages_path).should_not exist

        attributes = {
          :id => 1,
          :title => 'This is a title',
          :body => 'This is a body',
          :message => 'This is a message'
        }

        page = Page.new(attributes)
        page.save

        page_local_file = (Pow(Notebook.local_pages_path)/page.basename)
        page_local_file.should exist
        page_local_file.read.should == page.local_attributes.to_yaml
      end
    end

    describe "basename" do
      it "should be the basename of the page's local file" do
        page = Page.new(:id => 1, :title => 'Testing: Title')
        page.basename.should == 'testing--title.yaml'
      end
    end

    describe "local_attributes" do
      it "should be the attributes of the page that can be saved locally" do
        attributes = {
          :id => 1,
          :title => 'This is a title',
          :body => 'This is a body',
          :message => 'This is a message'
        }

        page = Page.new(attributes)
        page.local_attributes.should == {
          :id => 1,
          :title => 'This is a title',
          :body => 'This is a body'
        }
      end
    end

    describe "changed?" do
      it "should be true if the page's local file was updated after the notebook's last pull timestamp" do
        notebook = Notebook.new('')
        notebook.last_updated_at = Time.now

        file = (Pow(Notebook.local_pages_path) / "1-title.yaml").create
        file.should_receive(:mtime).and_return(notebook.last_updated_at + 60)

        page = Page.new(:notebook => notebook, :local_file => file)
        page.should be_changed
      end

      it "should be false if the page's local file is the same as last pull timestamp" do
        notebook = Notebook.new('')
        notebook.last_updated_at = Time.now

        file = (Pow(Notebook.local_pages_path) / "1-title.yaml").create
        file.should_receive(:mtime).and_return(notebook.last_updated_at)

        page = Page.new(:notebook => notebook, :local_file => file)
        page.should_not be_changed
      end
    end

    describe "push" do
      it "should push the page's remote attributes to unfuddle" do
        notebook = Notebook.new('http://test.unfuddle.com')
        stub_request(:put, notebook["pages/1"].url.to_s).to_return(:body => '')

        page = Page.new(:notebook => notebook, :id => 1)
        page.push
      end
    end

    describe "remote_attributes" do
      it "should be the attributes that can be put to unfuddle" do
        expected_attributes = {
          :title => 'This is a title',
          :body => 'This is a body',
          :message => 'This is a message'
        }

        page = Page.new(expected_attributes.merge(:id => 1))
        page.remote_attributes.should == expected_attributes
      end
    end
  end
end
