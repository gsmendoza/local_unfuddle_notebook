require 'local_unfuddle_notebook'
require 'bundler/setup'
require 'ruby-debug'
require 'webmock/rspec'

Spec::Runner.configure do |config|
  config.before :each do
    LocalUnfuddleNotebook::Notebook.stub(:local_pages_path).and_return("tmp/pages")
    if Pow(LocalUnfuddleNotebook::Notebook.local_pages_path).exists?
      Pow(LocalUnfuddleNotebook::Notebook.local_pages_path).delete!
    end

    LocalUnfuddleNotebook::Notebook.stub(:attributes_path).and_return("tmp/local_unfuddle_notebook.yaml")
    if Pow(LocalUnfuddleNotebook::Notebook.attributes_path).exists?
      Pow(LocalUnfuddleNotebook::Notebook.attributes_path).delete
    end
  end
end

