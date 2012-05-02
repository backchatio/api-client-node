# BackChat.io Client for Node.js

This is a light library to access the Backchat provisioning API.

## Current version

0.1

## Installation

    npm install backchatio-api

## Usage

You need a valid API key to access the Backchat API.

Load the `backchatio-api` library.

    var BC = require('backchatio-api');

Open a client.

    BC.backchat.open('<apiKey>', function(client) {
        ...
    });

The `open` method requires 2 parameters: `apiKey` and  `callback`. The
`callback` function must take one parameter, `client`, and is called as soon as
the client is initialized and ready to be used.

Execute an API operation.

    client['<api>']['<operation>'](args, function (errors, data) {
        if (errors) {
            console.log(errors);
        } else {
            console.log(data);
        }
    });

or equivalent

    client.<api>.<operation>(args, function (errors, data) {
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
    

    BC.backchat.open('<apiKey>', function(client) {
        client.account.userDetails(function (errors, data) {
            ...
        });
    });

Get the details of a stream:
    

    BC.backchat.open('<apiKey>', function(client) {
        client.streams.streamDetails({streamSlug: '<slug>'}, function (errors, data) {
            ...
        });
    });

## License

MIT licensed, check the [LICENSE](https://github.com/mojolly/backchat-node-client/blob/master/LICENSE) file.