$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib = File.join(File.dirname(__FILE__), '..', 'lib'))

Dir["#{lib}/**/*"].each {|file| require file }

require 'ruby-debug'
