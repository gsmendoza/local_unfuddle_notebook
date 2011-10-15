$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib = File.join(File.dirname(__FILE__), '..', 'lib'))

Dir["#{lib}/**/*"].each {|file| require file }

require 'ruby-debug'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :webmock
end

Spec::Runner.configure do |config|
  config.before :each do
    LocalUnfuddleNotebook::App.stub(:config_path).and_return("tmp/local_unfuddle_notebook.yaml")
    Pow(LocalUnfuddleNotebook::App.config_path).delete if Pow(LocalUnfuddleNotebook::App.config_path).exists?
  end
end

