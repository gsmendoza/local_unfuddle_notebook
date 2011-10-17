require 'pow'

Pow("lib/local_unfuddle_notebook").glob("/**/*").each do |file|
  require file unless file == "lib/local_unfuddle_notebook/version.rb"
end

module LocalUnfuddleNotebook
end
