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
      Notebook.with_attributes(options).pull
    end

    desc "pull", "Update the local copy of your unfuddle notebook"
    def pull
      Notebook.local.pull
    end

    desc "status", "Check which pages have been updated locally"
    def status
      puts "Pages changed locally:"
      puts Notebook.local.local_pages.select(&:changed?).map{|page|
        page.local_file.name(true)
      }.sort
    end
  end
end

