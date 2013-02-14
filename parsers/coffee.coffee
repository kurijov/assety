class CoffeeCompiler extends require("../abstract")
  @extensions: ['.coffee']

  _parse: (content) ->
    # res.header "Content-type", "text/javascript"
    try
      data = require("coffee-script").compile content, bare: yes
    catch e
      error = """
        I wasnt able to compile <b>#{@path}</b><br />#{e.toString().replace(/([\\"'])/g, "\\$1").replace(/\0/g, "\\0")}
      """
      data = "document.write('#{error}')"
    
    # res.send data
    data

  respond: (data, res, next) ->
    res.header "Content-type", "text/javascript"
    res.send data

module.exports = CoffeeCompiler