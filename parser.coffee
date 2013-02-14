_    = require "underscore"
log  = console.log 
Path = require("path")
fs   = require "fs"

class Parser
  constructor: ->
    @packages = {}
    @dont_search_directives = []
    @lookup_extensions = []

    @associations = 
      "___abstract___" : require("./abstract")
    
    # reading compilers
    # and getting available extensions for lookup
    files = fs.readdirSync parserPath = __dirname + "/parsers/"
    for file in files
      continue if Path.extname(file) isnt '.coffee'

      compiler = require(parserPath + file)
      for ext in compiler.extensions
        @lookup_extensions.push ext
        if compiler.search_directives is no # dont search directives inside compiled file
          @dont_search_directives.push ext

        @associations[ext] = compiler



    for k, v of @associations
      v.parser = @

  abstractCompiler: ->
    @associations["___abstract___"]

  setOptions: (options) ->
    options = _.defaults options, {
      assets_path : __dirname + "/assets"
      url_path    : "/url"
      public      : ""
    }

    @options = options
    @collectFiles()
    @

  collectFiles: () ->
    @_files = []
    @_collectFiles @options.assets_path, ""

  _collectFiles: (path, store = "") ->
    files = fs.readdirSync path

    for file in files
      fullPath  = path + "/" + file
      storePath = store + "/" + file
      stats     = fs.statSync fullPath

      if stats.isFile()
        @_files.push storePath
      else if stats.isDirectory()
        @_collectFiles fullPath, storePath

  find: (item) ->
    for file in @_files
      for ext in @lookup_extensions
        index = file.indexOf item + ext
        if index > -1
          return file

  urlPaths: (path) ->
    compiler  = new (@abstractCompiler()) path
    paths     = compiler.urlPaths()

  getCompiler: (path) ->
    ext      = Path.extname path
    new (@associations[ext]) path

  parse: (path, res, next) ->
    # file     = @find path
    ext      = Path.extname path
    
    # fileData = fs.readFileSync file
    if @associations[ext]
      c = new (@associations[ext]) path

      c.parse res, next
    else
      next()

  package: (path) ->
    unless @packages[path]
      compiler = new (@abstractCompiler()) path
      @packages[path] = compiler.package()

    @packages[path]

module.exports = Parser