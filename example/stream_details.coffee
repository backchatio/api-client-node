#
# This example demonstrates how to get the details for a stream with
# the BackChat.io API client.
#
# Usage:
#
#     coffee example/stream_details.coffee apikey stream_slug
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
  # Calls the `streamDetails` method on the `streams` API and passes a callback which
  # will be called to provide the results of the operation.
  client.api.streams.streamDetails {streamSlug: process.argv[3]}, (errors, stream) ->
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
      console.log stream
      console.log 'Name: %s', stream.name
      console.log 'Description: %s', stream.description
      console.log 'Slug: %s', stream.slug
      console.log 'HTTP: %s', stream.urls.http
      console.log 'Websocket: %s', stream.urls.websocket
      console.log 'Channel filters:'
      _.each stream.channelFilters, (cf) ->
        console.log '\tChannel: %s', cf.channel
        console.log '\tFilter: %s', cf.filter

# When the client can't connect to the BackChat API
client.on 'error', () ->
  console.log "Couldn't connect to BackChat API: %s", client.errors