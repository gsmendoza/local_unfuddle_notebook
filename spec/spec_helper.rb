require 'local_unfuddle_notebook'
require 'bundler/setup'

Spec::Runner.configure do |config|
  config.before :each do
    LocalUnfuddleNotebook::Notebook.stub(:connection_settings_path).and_return("tmp/local_unfuddle_notebook.yaml")
    if Pow(LocalUnfuddleNotebook::Notebook.connection_settings_path).exists?
      Pow(LocalUnfuddleNotebook::Notebook.connection_settings_path).delete
    end
  end
end

