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
          :message => 'This is a message',
          :updated_at => Time.now
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
        page.basename.should == '1-testing--title.yaml'
      end
    end

    describe "local_attributes" do
      it "should be the attributes of the page that can be saved locally" do
        updated_at = Time.now
        attributes = {
          :id => 1,
          :title => 'This is a title',
          :body => 'This is a body',
          :message => 'This is a message',
          :updated_at => updated_at
        }

        page = Page.new(attributes)
        page.local_attributes.should == {
          :title => 'This is a title',
          :body => 'This is a body',
          :message => 'This is a message',
          :updated_at => updated_at
        }
      end
    end
  end
end
