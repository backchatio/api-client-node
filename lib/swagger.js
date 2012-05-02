var Request = require('request');
var Async = require('async');
var Url = require('url');
var S = require('string');
var _ = require('underscore');

var debug = false;

var Client = function(meta, authHeaders, responseHandler) {
  this.meta = meta;
  this.authHeaders = authHeaders;
  var rp = responseHandler || ResponseHandler;
  for(var i=0, len=meta.apis.length; api=meta.apis[i], i<len; i++) {
    this[api.name] = new Api(api, this, rp);
  }
}

Client.prototype.submit = function(method, path, pathParams, headerParams, queryParams, callback) {
  var request = null;

  if (method == 'GET')
    request = Request.get;
  else if (method == 'POST')
    request = Request.post;
  else if (method == 'PUT')
    request = Request.put;
  else if (method == 'DELETE')
    request = Request.del;

  pathParams['format'] = 'json';

  for (authHeaderName in this.authHeaders)
    headerParams[authHeaderName] = this.authHeaders[authHeaderName];

  headerParams['Content-Type'] = 'application/json';

  for(name in pathParams)
    path = path.replace('{' + name + '}', pathParams[name]);

  var url = this.meta.basePath + path.substr(1);

  if (debug) console.log(method + ' request path: ' + url + ' with params:');

  var options = {url:url, headers:headerParams};

  if (debug) console.log(queryParams);

  if (method == 'POST' || method == 'PUT')
    options.form = queryParams;
  else
    options.qs = queryParams;

  request(options, function (e, r, body) {
    callback(e, r, body);
  });
}

var Api = function(meta, client, responseHandler) {
  for(var i=0, len=meta.operations.length; op=meta.operations[i], i<len; i++) {
    this[op.name] = (function(op) { return function(args, callback) {
      var pathParams = {};
      var headerParams = {};
      var queryParams = {};
      if (_.isFunction(args)) {
        callback = args;
        args = {};
      }
      for (name in args) {
        op.params.withParam(S(name).underscore().s, function (param, paramType) {
          var params = param(args[name]);
          if (paramType == 'path')
            pathParams[params[0][0]] = params[0][1];
          else if (paramType == 'query')
            _.each(params, function(p) {
              if (!_.has(queryParams, p[0])) {
                queryParams[p[0]] = []
              }
              queryParams[p[0]].push(p[1]);
            });
          else if (paramType == 'header')
            headerParams[params[0][0]] = params[0][1];
        })
      }
      var handler = new responseHandler(op);
      client.submit(op.httpMethod, op.path, pathParams, headerParams, queryParams, function(error, response, body) {
        var response = handler.eval(error, response, body);
        callback(response.errors, response.data);
      });
    }})(op);
  }
}

var ResponseHandler = function(meta) { // TODO
  this.meta = meta;
  this.eval = function(error, response, body) {
    return {
      data:[]
    };
  }
}

var Params = function (meta, models) {
  this.params = meta;
  this.models = models;
}

Params.prototype.withParam = function (name, f) {
  var that = this;
  var param = null;
  name = S(name).underscore().s
  for (k in this.params) {
    var p = this.params[k];
    if (p.name) {
      if (p.name == name)
        param = p;
        paramType = p.paramType;
    } else {
      for (mi in this.models) {
        var model = this.models[mi];
        if (model.properties[name]) {
          paramType = p.paramType;
          param = model.properties[name]
        }
      }
    }
  }
  if (param)
    f(function (arg) {
      return toParams(name, arg);
    }, paramType);
}

var toParams = function(name, arg, parents) {
  parents = parents || [];
  var all = parents.concat([name])
  full_name = _.map(all, function(a){ return S(a).underscore().s; }).join('.');
  var l = [];
  if (_.isString(arg))
    l = [[full_name, arg]]
  else if (_.isNumber(arg))
    l = [[full_name, arg]]
  else if (_.isBoolean(arg))
    l = [[full_name, arg]]
  else if (_.isDate(arg))
    l = [[full_name, arg]]
  else if (_.isArray(arg)) {
    l = _.reduce(arg, function(m, a) {
      var r = m.concat(toParams(name, a, parents));
      return r;
    }, []);
  }
  else if (_.isObject(arg))
    l = _.reduce(_.keys(arg), function(m, k) {
      var r = m.concat(toParams(k, arg[k], all));
      return r;
    }, []);
  return l;
}

var fetchResource = function(url, name, cb) {
  Request.get(url, function(e, r, b) {
    var j = JSON.parse(b);
    j.name = name;
    cb(null, j);
  });
}

var toMeta = function(index, resources) {
  var meta = { basePath:index.basePath };
  meta.apis  = _.reduce(resources, function(m, r) {
    var models = r.models
    var ops = _.reduce(r.apis, function(m, r) {
      var api= r;
      var a = _.map(r.operations, function(op) {
        var params = _.map(op.parameters, function(param) {
          return {name:param.name, paramType:param.paramType};
        });
        return {name:op.nickname,
          httpMethod:op.httpMethod,
          path:api.path,
          params:new Params(params, models)};
      });
      return m.concat(a);
    }, []);
    m.push({ name:r.name, operations:ops });
    return m;
  }, []);
  return meta;
}

var fetchMeta = function(url, cb) {
  Request.get(url + '/resources.json', function(e, r, b) {
    var j = JSON.parse(b);
    Async.series(_.map(j.apis, function(a) {
      return function(scb){
        var name = a.path.substr(1, a.path.length - 10);
        fetchResource(url + a.path.replace('{format}', 'json'), name, scb)
      }
    }), function(err, results){ cb(j, results)});
  });
}

var jsToData = function(data) {
  if (_.isArray(data)) {
    return _.map(data, function(d) {
      return jsToData(d);
    });
  }
  else if (_.isObject(data)) {
    return _.reduce(_.keys(data), function(m, k) {
      m[S(k).camelize().s] = jsToData(data[k]);
      return m;
    }, {});
  }
  else {
    return data;
  }
}

module.exports.toData = jsToData

module.exports.setDebug = function (d) {
  debug = d;
}

module.exports.open = function(url, authHeaders, responseHandler, cb) {
  fetchMeta(url, function(listing, resources) {
    cb(new Client(toMeta(listing, resources), authHeaders, responseHandler));
  });
}

module.exports.open_sync = function(url, authHeaders, responseHandler) {
  return null; // TODO
}

module.exports.Client = Client