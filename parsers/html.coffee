Path = require "path"

class HtmlCompiler extends require("../abstract")
  @extensions: ['.html']
  @search_directives: no

  _parse: (content) ->
    # res.header "Content-type", "text/javascript"
    data = content.replace(/\r?\n/g, "\\n").replace(/\'/g, '\\\\\'')

    path = @path.substr 0, @path.length - Path.extname(@path).length

    template = """
      if (!window.JST) {
        window.JST = {};
      }
      window.JST["#{path}"] = _.template('#{data}');
    """

    # res.send template
    template

  respond: (data, res, next) ->
    res.header "Content-type", "text/javascript"
    res.send data

module.exports = HtmlCompiler