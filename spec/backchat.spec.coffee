Index = require("index.js")
Backchat = Index.backchat
Swagger = Index.swagger
_ = require("underscore")

describe "Backchat", ->

  describe "open", ->

    it "should throw an error when no argument is passed", ->
      e = new Error("undefined is not a valid apiKey or options object.")
      expect(-> Backchat.open()).toThrow e

    it "should create a Swagger client", ->
      spyOn Swagger, "open"
      runs ->
        @apiKey = "apiKey"
        that = this
        @callback = (client) ->
          that.client = client
        Backchat.open @apiKey, @callback
      waits 500
      runs ->
        expect(Swagger.open).toHaveBeenCalledWith {url: "https://api.backchat.io/1/swagger"
        , authHeaders: {"Authorization": "Backchat apiKey"}
        , responseHandler: Backchat.responseHandlerFactory}, @callback

  describe "ResponseHandler", ->
    handler = undefined
    beforeEach ->
      handler = new Backchat.ResponseHandler()

    it "should return an error when the request is unauthorized", ->
      msg = "Unauthorized"
      r = handler.handle(undefined, {statusCode: 401}, msg)
      expect(r.data).toBeUndefined()
      expect(r.errors).toContain {message: msg}

    it "should return empty data object when response without content", ->
      r = handler.handle(undefined, {statusCode: 204}, undefined)
      expect(r.data).toEqual {}
      expect(r.errors).toBeUndefined()

    it "should return data parsed from json response", ->
      data = "foo"
      spyOn(Swagger, "toData").andReturn data
      body = JSON.stringify {errors:[], data:data}
      r = handler.handle(undefined, {statusCode: 200}, body)
      expect(r.data).toEqual data
      expect(r.errors).toBeUndefined()

    it "should return errors parsed from json response", ->
      errors = [{code: {error: "foo", message: "bar"}}]
      body = JSON.stringify {errors:errors, data:undefined}
      r = handler.handle(undefined, {statusCode: 409}, body)
      expect(r.data).toBeUndefined()
      expect(r.errors).toEqual errors
