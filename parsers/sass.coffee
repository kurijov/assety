class SassCompiler extends require("../abstract")
  @extensions: ['.sass']

  _parse: (content) ->
    # res.header "Content-type", "text/css"
    css = require("sass").render content
    # res.send css
    css

  respond: (data, res, next) ->
    res.header "Content-type", "text/css"
    res.send data

module.exports = SassCompiler