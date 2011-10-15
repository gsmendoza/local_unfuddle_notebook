$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib = File.join(File.dirname(__FILE__), '..', 'lib'))

Dir["#{lib}/**/*"].each {|file| require file }

require 'ruby-debug'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.stub_with :webmock
end
