require 'local_unfuddle_notebook'
require 'bundler/setup'

Spec::Runner.configure do |config|
  config.before :each do
    LocalUnfuddleNotebook::App.stub(:config_path).and_return("tmp/local_unfuddle_notebook.yaml")
    Pow(LocalUnfuddleNotebook::App.config_path).delete if Pow(LocalUnfuddleNotebook::App.config_path).exists?
  end
end

