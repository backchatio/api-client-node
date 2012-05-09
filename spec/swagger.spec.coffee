Index = require("index.js")
Backchat = Index.backchat
Swagger = Index.swagger

Request = require("request")
FS = require("fs")
_ = require("underscore")

_.str = require('underscore.string')
_.mixin(_.str.exports())

describe "Swagger", ->

  describe "toData", ->

    it "should just return strings", ->
      s = "a string"
      expect(Swagger.toData(s)).toEqual(s)

    it "should just return numbers", ->
      n = 999
      expect(Swagger.toData(n)).toEqual(n)

    it "should camelize keys in objects", ->
      expect(Swagger.toData({foo: "baz", foo_bar: "bar"})).toEqual({foo: "baz", fooBar: "bar"})

    it "should camelize keys in arrays of objects", ->
      expect(Swagger.toData([{foo: "baz", foo_bar: "bar"}])).toEqual([{foo: "baz", fooBar: "bar"}])


  describe "fetchMeta", ->

    it "should fetch the resource listings and pass them to the callback", ->
      base = "http://foobar/1/swagger"
      f = (url, cb) ->
        fname = _(url).strRightBack("/")
        FS.readFile "./spec/" + fname, (err, data) ->
          throw err  if err
          cb `undefined`, `undefined`, data
      spyOn(Request, "get").andCallFake f
      runs ->
        that = this
        @callback = (listing, resources) ->
          that.listing = listing
          that.resources = resources
        Swagger.fetchMeta base, @callback
      waits 500
      runs ->
        expect(this.listing).toBeDefined()
        expect(this.resources).toBeDefined()
        expect(this.resources.length).toEqual(2)

  describe "Client", ->

    it "should have a property for each API", ->
      client = new Swagger.Client({apis: [
        {name: "foo", operations: []},
        {name: "bar", operations: []}
      ]})
      expect(client.foo).toBeDefined()
      expect(client.bar).toBeDefined()