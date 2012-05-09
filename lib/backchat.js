var Swagger = require('./swagger');
var _ = require('underscore');

// The default BackChat.io API resource discovery URL.
var BackchatApiUrl = 'https://api.backchat.io/1/swagger';

// Handler for the specific reponse format returned by the BackChat.io API.
//
var ResponseHandler = module.exports.ResponseHandler = function(meta) {
  this.meta = meta;
  this.handle = function(error, response, body) {
    var errors, data, json, code = response.statusCode;
    if (_.include([401, 504], code)) {
      errors = [{message:body}];
    } else if (code === 204) {
      data = {};
    } else {
      json = JSON.parse(body);
      if (json.errors && json.errors.length > 0) {
        errors = json.errors;
      } else {
        data = Swagger.toData(json.data);
      }
    }
    return {
      data:data,
      errors:errors
    };
  };
};

// Creates a new BackChat.io API client.
module.exports.open = function(apiKey, options, callback) {
  if (typeof apiKey === 'undefined') {
    throw new Error('undefined is not a valid apiKey or options object.');
  }
  if ((typeof options === 'function') && !callback) {
    callback = options;
  }
  if (typeof options === 'object') {
    options.apiKey = apiKey;
  } else if (typeof apiKey === 'string') {
    options = {apiKey:apiKey};
  } else {
    options = apiKey;
  }
  if (callback) {
    options.callback = callback;
  }
  options.url = options.url || BackchatApiUrl;
  Swagger.open({url: options.url,
    authHeaders: {'Authorization':'Backchat '+options.apiKey},
    responseHandler: function(op) { return new ResponseHandler(op); }},
    options.callback);
};