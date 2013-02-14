class CssCompiler extends require("../abstract")
  @extensions: ['.css']

  _parse: (content, res, next) ->
    # res.header "Content-type", "text/css"
    # res.send content
    content

  respond: (data, res, next) ->
    res.header "Content-type", "text/css"
    res.send data

module.exports = CssCompiler