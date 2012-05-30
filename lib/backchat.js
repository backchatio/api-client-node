var Swagger = require('./swagger'),
    util = require('util'),
    events = require('events'),
    _ = require('underscore');

/**
 * The default BackChat.io API resource discovery URL.
 *
 * @private
 */
var BackchatApiUrl = 'https://api.backchat.io/1/swagger';

/**
 * Handler for the specific reponse format returned by the BackChat.io API.
 *
 * @private
 * @constructor
 */
var ResponseHandler = function(meta) {
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

/**
 * Creates a new BackChat.io client.
 *
 * @class
 *
 * The BackchatClient provides a client for BackChat.io. The client emits the following events:
 * <ul>
 * <li>'ready' when the client is initialized and ready to be used</li>
 * <li>'error' when the client failed to initialize properly</li>
 * </ul>
 *
 * Usage:
 *
 * <pre>
 * var client = new backchat.BackchatClient('<api_key>');
 * client.on('ready', function() {
 *   client.api.account.userDetails();
 * });
 * </pre>
 *
 * @augments events.EventEmitter
 *
 * @param {String|Object} options a valid API key or an options object
 * @param {String} options.apiKey a valid API key
 * @param {String} [options.url] the api URL
 *
 * @property {Object} api the api object for working with the BackChat.io API 
 *
 * @throws {Error} if the options argument is undefined or invalid
 */
var BackchatClient = function(options) {
  events.EventEmitter.call(this);
  if (typeof options === 'undefined') {
    throw new Error('undefined is not a valid apiKey or options object.');
  }
  if (typeof options === 'string') {
    options = {apiKey: options};
  }
  if (typeof options === 'object') {
    options.url = options.url || BackchatApiUrl;
  } else {
    throw new Error('options is not a valid options object.');
  }
  var self = this;
  Swagger.open({url: options.url,
    authHeaders: {'Authorization':'Backchat '+options.apiKey},
    responseHandler: function(op) { return new ResponseHandler(op); }},
    function(client) {
      self.api = client;
      self.emit('ready');
    });
};

util.inherits(BackchatClient, events.EventEmitter);

module.exports.ResponseHandler = ResponseHandler;
module.exports.BackchatClient = BackchatClient;