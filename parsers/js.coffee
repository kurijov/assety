class JsCompiler extends require("../abstract")
  @extensions: ['.js']

  _parse: (content, res, next) ->
    # res.header "Content-type", "text/javascript"
    # res.send content
    content

  respond: (data, res, next) ->
    res.header "Content-type", "text/javascript"
    res.send data

module.exports = JsCompiler