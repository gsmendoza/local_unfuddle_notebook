module LocalUnfuddleNotebook
  class App < Valuable
    has_value :args

    def execute
      #case options.command
      #when 'checkout'
        #init.notebook.pull
      #when 'push'
        #notebook.push options.message
      #when 'pull'
        #notebook.pull
      #else
        puts slop.help
      #end
    end

    def slop
      @slop ||= Slop.parse(args, :help => true) do
        banner "Save your unfuddle notebook locally"

        #command :checkout do
          #banner "download remote unfuddle notebook"
          #on :s, :subdomain, "Unfuddle subdomain", :options => false
          #on :u, :username, "Unfuddle username", :options => false
          #on :p, :password, "Unfuddle password", :options => false
          #on :pid, :project_id, "Unfuddle project id", :options => false
          #on :nid, :notebook_id, "Unfuddle notebook id", :options => false
        #end

        #command :push do
          #banner "upload local copy to remote unfuddle notebook"
          #on :m, :message, "Message", :options => false
        #end

        #command :pull do
          #banner "update the local copy of your unfuddle notebook"
        #end
      end
    end
  end
end

