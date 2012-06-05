#
# This example demonstrates how to compose a URI with
# the BackChat.io API cllient.
#
# Usage:
#
#     coffee example/compose_uri.coffee original_uri target
#
# Example:
#
#     coffee example/compose_uri.coffee 'twitter://backchatio' 'twitter'
#

# Requires the `backchat` module
Backchat = require("index.js").backchat
_ = require("underscore")

# Creates an object with an `url` property to override the resource discovery URL.
# This step is not required and is only useful for development purposes.
options = (if process.env.BC_HOST then {url: process.env.BC_HOST} else {})

# Creates a new client and passes in a valid API key or an options object
client = new Backchat.BackchatClient options

# When the client is ready to be used
client.on 'ready', () ->
  # Calls the `composeUri` method on the `account` API and passes a callback which
  # will be called to provide the results of the operation.
  client.api.account.composeUri {originalChannel: process.argv[2], target: process.argv[3]}, (errors, uri) ->
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
      console.log 'Canonical URI: %s', uri.canonicalUri
      console.log 'Target: %s', uri.target
      console.log 'Source: %s', uri.source
      console.log 'Kind: %s', uri.kind

# When the client can't connect to the BackChat API
client.on 'error', () ->
  console.log "Couldn't connect to BackChat API: %s", client.errors