#
# This example demonstrates how to get the account details with
# the BackChat.io API cllient.
#
# Usage:
#
#     coffee examples/user_details.coffee apikey [apihost]
#

# Requires the `backchat` module
Backchat = require("index.js").backchat
_ = require("underscore")

# Read the API key from command line arguments
apiKey = process.argv[2]

# Creates an object with an `url` property to override the resource discovery URL.
# This step is not required and is only useful for development purposes.
options = (if process.argv[3] then {url: process.argv[3]} else {})

# Calls the `open` function and passes in a valid API key (and optionally the extra
# `options` object) and a callback function.
Backchat.open apiKey, options, (client) ->
  # Calls the `userDetails` method on the `account` API and passes a callback which
  # will be called to provide the results of the operation.
  client.account.userDetails (errors, details) ->
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
      console.log 'Name: %s %s', details.firstName, details.lastName
      console.log 'Email: %s', details.email
      console.log 'Login: %s', details.login
      console.log 'API key: %s', details.apiKey