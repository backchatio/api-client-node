#
# This example demonstrates how to add a new channel with
# the BackChat.io API cllient.
#
# Usage:
#
#     coffee example/create_channel.coffee apikey channel
#
# Example:
#
#     coffee example/create_channel.coffee bf5c48b9df106cb1e4da7722ec2085a5 'twitter://backchatio'
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
  # Calls the `createChannel` method on the `channels` API and passes a callback which
  # will be called to provide the results of the operation.
  client.api.channels.createChannel {uri: process.argv[3]}, (errors, channel) ->
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
      console.log 'Channel created successfully!'
      console.log 'Channel URI: %s', channel.uri
      console.log 'Canonical URI: %s', channel.expanded.canonicalUri
      console.log 'Target: %s', channel.expanded.target
      console.log 'Source: %s', channel.expanded.source
      console.log 'Kind: %s', channel.expanded.kind

# When the client can't connect to the BackChat API
client.on 'error', () ->
  console.log "Couldn't connect to BackChat API: %s", client.errors