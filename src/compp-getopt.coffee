# node standard modules
fs = require 'fs'

defineArgRegex = /^\-D/g
undefArgRegex = /^\-U/g
includeArgRegex = /^\-I/g
outputArgRegex = /^\-o/g
helpArgRegex = /^\-h/g
versionArgRegex = /^\-v/g

displayHelp = ->
  console.log '''
    Usage: compp [-Dmacro[=defn]...] [-Umacro]
                 [-Idir] [-o outfile]
                 infile [outfile]
  '''

displayVersion = ->
  fs.readFile "#{__dirname}/../package.json", (err, file) ->
    throw err if err
    console.log "compp version #{JSON.parse(file.toString()).version}"

parseArgsFromArr = (argArr) ->
  exec = argArr.shift()
  help = no
  version = no
  defines = []
  undefs = []
  includes = []
  output = []
  # list of arguments without minuses
  argv = []
  prevWasOutputFlag = no
  for arg in argArr
    if prevWasOutputFlag
      output.push arg
      prevWasOutputFlag = no
    else if arg.match defineArgRegex
      defines.push arg.replace defineArgRegex, ""
    else if arg.match undefArgRegex
      undefs.push arg.replace undefArgRegex, ""
    else if arg.match includeArgRegex
      includes.push arg.replace includeArgRegex, ""
    else if arg.match outputArgRegex
      if (arg.replace outputArgRegex, "") is ""
        prevWasOutputFlag = yes
      else
        output.push arg.replace outputArgRegex, ""
    else if arg.match helpArgRegex
      help = yes
    else if arg.match versionArgRegex
      version = yes
    else
      argv.push arg
  return {
    exec: exec,
    argv: argv,
    help: help,
    version: version
    defines: defines
    undefs: undefs
    includes: includes
    output: output
  }

module.exports =
  displayHelp: displayHelp
  displayVersion: displayVersion
  parseArgsFromArr: parseArgsFromArr
