_    = require "underscore"
log  = console.log 
Path = require("path")
fs   = require "fs"


class AbstractCompiler
  @search_directives : yes
  item_regex        : /^[\W]*=\s*(\w+.*?)(\*\\\/)?$/gm
  directive_regex   : /(require|require_tree)\s+([a-z-\/_0-9\.]+)/i

  constructor: (path) ->
    @path = path

    @collected = []

  parser: ->
    AbstractCompiler.parser

  add: (path) ->
    unless path in @collected
      @collected.push path

  collectPaths: ->
    @_collectPaths @path

  _collectPaths: (abstractPath) ->
    path         = @parser().find "/" + abstractPath
    unless path
      return log "no path for #{abstractPath}"

    

    # @TODO
    if Path.extname(path) not in @parser().dont_search_directives
      

      fileContents = fs.readFileSync @parser().options.assets_path + path
      directives   = fileContents.toString().match @item_regex
      directives or= []

      # log directives

      for directive in directives
        item = directive.match @directive_regex
        [match, command, file] = item
        log command, file
        if command is "require"
          @__require file
        else if command is "require_tree"
          @__require_tree file
    else
      log "#{abstractPath}:: skipping directives lookup"

    @add path

  __require_tree: (abstractPath) ->
    for listfile in @parser()._files
      if listfile.indexOf(abstractPath) > -1
        # log 'collect', listfile.substr(1, listfile.length - Path.extname(listfile).length - 1)
        @_collectPaths listfile.substr(1, listfile.length - Path.extname(listfile).length - 1)

  __require: (abstractPath) ->
    exactPath = @parser().find abstractPath
    if exactPath
      @add exactPath
    else
      log "::: I couldnt find #{abstractPath}"

    @_collectPaths abstractPath

  urlPaths: () ->
    # log "1111111111"
    @collectPaths()
    for i in @collected
      @parser().options.url_path + i

  package: () ->
    associations = {
      ".coffee" : ".js"
      ".js"     : ".js"
      ".sass"   : ".css"
      ".html"   : ".js"
    }

    fileext = associations[Path.extname(@parser().find @path)]

    filename = @path.replace(/\//g, "_") + new Date().getTime() + fileext

    @collectPaths()
    contents = ""
    for file in @collected
      compiler = @parser().getCompiler file
      contents += compiler.__parse() + "\n"

    fs.writeFileSync @parser().options.public + "/" + filename, contents
    "/" + filename

  run: ->
    paths = @collectPaths()

  __parse: ->
    file = @path
    unless Path.extname(@path)
      file = @find @path


    data = fs.readFileSync @parser().options.assets_path + file
    data = data.toString()
    @_parse data


  parse: (res, next) ->
    data = @__parse()
    @respond data, res, next

module.exports = AbstractCompiler