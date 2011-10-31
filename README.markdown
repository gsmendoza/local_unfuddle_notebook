    > lunbook help

    Tasks:
      lunbook checkout     # Download unfuddle notebook and save locally.
      lunbook help [TASK]  # Describe available tasks or one specific task
      lunbook pull         # Update the local copy of your unfuddle notebook
      lunbook push         # Upload updated pages to your unfuddle notebook
      lunbook status       # Check which pages have been updated locally


    Usage:
      lunbook checkout

    Options:
      -p, [--password=PASSWORD]        # Unfuddle password (required)
      -s, [--subdomain=SUBDOMAIN]      # Unfuddle subdomain (required)
      -u, [--username=USERNAME]        # Unfuddle username (required)
      -r, [--project-id=PROJECT_ID]    # Unfuddle project id (required)
      -n, [--notebook-id=NOTEBOOK_ID]  # Unfuddle notebook id (required)
      -o, [--protocol=PROTOCOL]        # http/https (default: http)

    Usage:
      lunbook push

    Options:
      -m, [--message=MESSAGE]  # Message

