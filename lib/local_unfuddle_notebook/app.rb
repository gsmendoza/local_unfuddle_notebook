module LocalUnfuddleNotebook
  class App < Valuable
    has_value :args
    has_value :command
    has_value :options

    def execute
      slop = parse_args

      case command
      when :checkout
        puts "#TODO"
        #init.notebook.pull
      when :push
        #notebook.push options.message
      when :pull
        #notebook.pull
      else
        puts "Invalid command"
        puts slop.help
      end
    end

    def parse_args
      app = self

      Slop.parse(args, :help => true) do
        banner "Save your unfuddle notebook locally.\nUsage: lunbook (checkout|push|pull)* (options)*"

        command :checkout do
          banner "Download remote unfuddle notebook"
          on :s, :subdomain, "Unfuddle subdomain", true
          on :u, :username, "Unfuddle username", true
          on :p, :password, "Unfuddle password", true
          on :r, :project_id, "Unfuddle project id", true
          on :n, :notebook_id, "Unfuddle notebook id", true

          execute do |opts, args|
            app.command = :checkout
            app.options = opts.to_hash
          end
        end

        #command :push do
          #banner "upload local copy to remote unfuddle notebook"
          #on :m, :message, "Message", :options => false

          #execute do |opts, args|
            #notebook.push options.message
          #end
        #end

        #command :pull do
          #banner "update the local copy of your unfuddle notebook"

          #execute do |opts, args|
            #notebook.pull
          #end
        #end
      end
    end
  end
end

