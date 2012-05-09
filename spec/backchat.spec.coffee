Index = require("index.js")
Backchat = Index.backchat
Swagger = Index.swagger
_ = require("underscore")

describe "Backchat", ->

  describe "open", ->
    beforeEach ->
      this.clientCallback = (client) -> client
      this.expectations = (expectedUrl) ->
        expectedUrl = expectedUrl || "https://api.backchat.io/1/swagger"
        expect(Swagger.open).toHaveBeenCalled()
        expect(this.options.url).toEqual(expectedUrl)
        expect(this.options.authHeaders).toEqual({"Authorization": "Backchat apiKey"})
        expect(this.options.responseHandler).toBeDefined
      that = this
      spyOn(Swagger, "open").andCallFake (o, cb) ->
        that.options = o
        that.callback = cb

    it "should throw an error when no argument is passed", ->
      e = new Error("undefined is not a valid apiKey or options object.")
      expect(-> Backchat.open()).toThrow e

    it "should create a Swagger client by passing an apiKey", ->
      Backchat.open "apiKey", @clientCallback
      @expectations()

    it "should create a Swagger client by passing an apiKey and options object", ->
      url = "http://localhost:8080/1/swagger"
      Backchat.open "apiKey", {url: url}, @clientCallback
      @expectations(url)

    it "should create a Swagger client by passing an options object", ->
      url = "http://localhost:8080/1/swagger"
      Backchat.open {apiKey: "apiKey", url: url}, @clientCallback
      @expectations(url)

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
