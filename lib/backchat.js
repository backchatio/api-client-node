var Swagger = require('./swagger');
var _ = require('underscore');

var backchatApiUrl = 'https://api.backchat.io/1/swagger';

var backchatAuthHeaders = function(apiKey) {
  return {'Authorization':'Backchat '+apiKey};
}

var ResponseHandler = function(meta) { // TODO
  this.meta = meta;
  this.eval = function(error, response, body) {
    var errors = null;
    var data = null;
    var code = response.statusCode;
    if (_.include([401, 504], code)) {
      errors = [{message:body}];
    } else if (code == 204) {
      data = {};
    } else {
      var r = JSON.parse(body);
      if (r.errors && r.errors.length > 0) {
        errors = r.errors;
      } else {
        data = Swagger.toData(r.data);
      }
    }
    return {
      data:data,
      errors:errors
    };
  }
}

module.exports.open = function(apiKey, options, callback) {
  if (typeof apiKey === 'undefined') throw new Error('undefined is not a valid apiKey or options object.')
  if ((typeof options === 'function') && !callback) callback = options;
  if (typeof options === 'object') {
    options.apiKey = apiKey;
  } else if (typeof apiKey === 'string') {
    options = {apiKey:apiKey};
  } else {
    options = apiKey;
  }
  if (callback) options.callback = callback;
  Swagger.open(options.url, backchatAuthHeaders(options.apiKey), ResponseHandler, options.callback);
}

module.exports.open_sync = function(apiKey) { // TODO
  Swagger.open_sync(backchatApiUrl, backchatAuthHeaders(apiKey), ResponseHandler);
}