Index = require("index.js")
Backchat = Index.backchat
Swagger = Index.swagger

describe "Backchat", ->
  describe "open", ->

    it "should throw an error when no argument is passed", ->
      e = new Error("undefined is not a valid apiKey or options object.")
      expect(-> Backchat.open()).toThrow e

    it "should create a Swagger client", ->
      spyOn Swagger, "open"
      runs ->
        @apiKey = "apiKey"
        @callback = (client) ->
          that.client = client

        that = this
        Backchat.open @apiKey, @callback

      waits 500
      runs ->
        expect(Swagger.open).toHaveBeenCalledWith "https://api.backchat.io/1/swagger",
          Authorization: "Backchat apiKey"
        , Backchat.responseHandlerFactory, @callback