require 'thor'

module LocalUnfuddleNotebook
  class App < Thor
    desc "checkout", "Download unfuddle notebook and save locally."
    method_option :subdomain,   :aliases => '-s', :desc => "Unfuddle subdomain"
    method_option :username,    :aliases => '-u', :desc => "Unfuddle username"
    method_option :password,    :aliases => '-p', :desc => "Unfuddle password"
    method_option :project_id,  :aliases => '-r', :desc => "Unfuddle project id"
    method_option :notebook_id, :aliases => '-n', :desc => "Unfuddle notebook id"
    def checkout
      puts "Notebook.init(#{options.inspect}).pull"
    end
  end
end

