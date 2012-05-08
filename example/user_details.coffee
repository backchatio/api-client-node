###
This example demonstrates how to get the account details with
the BackChat.io API cllient.

Usage:
  coffee examples/user_details.coffee apikey [apihost]
###

Backchat = require("index.js").backchat
_ = require("underscore")

apiKey = process.argv[2]
options = (if process.argv[3] then {url: process.argv[3]} else {})

Backchat.open apiKey, options, (client) ->
  client.account.userDetails (errors, details) ->
    if errors
      console.log 'Oops, something went wrong!'
      _.each errors, (error) ->
        console.log 'Error: %s', error.message
    else
      console.log 'Name: %s %s', details.firstName, details.lastName
      console.log 'Email: %s', details.email
      console.log 'Login: %s', details.login
      console.log 'API key: %s', details.apiKey