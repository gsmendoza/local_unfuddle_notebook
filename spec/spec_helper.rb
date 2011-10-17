require 'local_unfuddle_notebook'
require 'bundler/setup'

Spec::Runner.configure do |config|
  config.before :each do
    LocalUnfuddleNotebook::Notebook.stub(:config_path).and_return("tmp/local_unfuddle_notebook.yaml")
    Pow(LocalUnfuddleNotebook::Notebook.config_path).delete if Pow(LocalUnfuddleNotebook::Notebook.config_path).exists?
  end
end

