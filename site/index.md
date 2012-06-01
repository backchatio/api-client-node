---
layout: backchatio
title: BackChat.io API Client
---

# BackChat.io API Client for Node.js

A Node.JS library providing easy access to the BackChat.io Platform REST API, allowing developers to create/edit/delete message channels, message streams, and configure user accounts programatically.

## Current version

0.1.1

## Installation

    npm install backchatio-api

You can also install the development version from the GitHub repository:

    npm install git://github.com/backchatio/api-client-node.git

## Usage

You need a valid API key to access BackChat.io.

Load the `backchatio-api` library.

    var backchat = require('backchatio-api').backchat;

Create a client.

    var client = new backchat.BackchatClient('<apiKey>');

The BackchatClient constructor requires 1 parameter: `apiKey`.

The client emits an event `ready` as soon as the client is initialized and
ready to be used.

    client.on('ready', function() {
      ... 
    });

Execute an API operation.

    client.api.['<sub_api>']['<operation>'](args, function (errors, data) {
        if (errors) {
            console.log(errors);
        } else {
            console.log(data);
        }
    });

or equivalent

    client.<sub_api>.<operation>(args, function (errors, data) {
        ...
    });

Each API method accepts two parameters: `args` and `callback`. The `callback`
parameter is always the last parameter when invoking the method. 

The `callback` parameter is required and must be a function. This function is
called to handle the response and should accept 2 parameters, the first one for
errors, the second for the data.

The `args` parameter is optional and is only required when you want/need to
supply arguments for the API operation. The arguments for the operation need to
be passed in as an object.

Please checkout the BackChat.io API documentation for an overview of all API's and
operations.

## Examples

Get the account details:
    

    client.api.account.userDetails(function (errors, data) {
      ...
    });

Get the details of a stream:
    
    client.api.streams.streamDetails({streamSlug: '<slug>'}, function (errors, data) {
      ...
    });

Also check out the 'example' directory.

## Patches
Patches are gladly accepted from their original author. Along with any patches, please state that the patch is your original work and that you license the work to the *api-client-node* project under the MIT License.

## License
MIT licensed. check the [LICENSE](https://github.com/backchatio/api-client-node/blob/master/LICENSE) file