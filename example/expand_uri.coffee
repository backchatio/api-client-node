#
# This example demonstrates how to expand an URI with
# the BackChat.io API cllient.
#
# Usage:
#
#     coffee example/expand_uri.coffee uri
#
# Example:
#
#     coffee example/expand_uri.coffee 'twitter://backchatio'
#

# Requires the `backchat` module
Backchat = require("index.js").backchat
_ = require("underscore")

# Read the API key from command line arguments
apiKey = process.argv[2]

# Creates an object with an `url` property to override the resource discovery URL.
# This step is not required and is only useful for development purposes.
options = (if process.env.BC_HOST then {url: process.env.BC_HOST, apiKey: apiKey} else apiKey)

# Creates a new client and passes in a valid API key or an options object
client = new Backchat.BackchatClient options

# When the client is ready to be used
client.on 'ready', () ->
  # Calls the `expandUri` method on the `account` API and passes a callback which
  # will be called to provide the results of the operation.
  client.api.account.expandUri {channel: process.argv[3]}, (errors, uris) ->
    if errors
      console.log 'Oops, something went wrong!'
      # The first argument `errors` is an array of objects and is only defined in
      # case something went wrong.
      _.each errors, (error) ->
        # An error object has at least a message indicating what went wrong.
        console.log 'Error: %s', error.message
    else
      # If everything went well, the second parameter contains the data returned
      # by the server.
      uri = uris[0]
      console.log 'Canonical URI: %s', uri.canonicalUri
      console.log 'Target: %s', uri.target
      console.log 'Source: %s', uri.source
      console.log 'Kind: %s', uri.kind

# When the client can't connect to the BackChat API
client.on 'error', () ->
  console.log "Couldn't connect to BackChat API: %s", client.errors