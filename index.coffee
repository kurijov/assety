_    = require "underscore"
log  = console.log 
Path = require("path")
fs   = require "fs"
Parser = require "./parser"

parser = new Parser

global._js = (path) ->
  if process.env.NODE_ENV is "production"
    paths = [parser.package(path)]
  else
    parser.collectFiles()
    paths = parser.urlPaths(path)


  urls = for path in paths
    """
      <script type="text/javascript" src="#{path}"></script>

    """
  urls.join("")

global._css = (path) ->
  if process.env.NODE_ENV is "production"
    paths = [parser.package(path)]
  else
    parser.collectFiles()
    paths = parser.urlPaths(path)
  
  urls = for path in paths
    """
      <link rel="stylesheet" href="#{path}" />

    """
  urls.join ""



init = (req, res, next) ->
  safeUrl = parser.options.url_path.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")
  safeUrl = "^" + safeUrl + ".*"
  matched = req.url.match(safeUrl)

  if matched
    parser.parse matched[0].substr(parser.options.url_path.length), res, next
  else
    next()


module.exports = (options) ->
  parser.setOptions options
  init