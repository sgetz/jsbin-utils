###
collection of usefull utility function

requires lodash and underscore string
###

#_.mixin(_.str.exports())

STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/g
ARGUMENT_NAMES = /([^\s,]+)/g

l = console.log



###
attempts to get the name of a function
###
getFnName = (fn) ->
  return fn.name if fn.name
  return fn.displayName if fn.displayName
  fromSourceString = /\W*function\s+([\w\$]+)\(/.exec(fn.toString())
  return fromSourceString[1] if _.size(fromSourceString) == 2
  ''

###
extracts a list of functions parameters from a function
###
getParamNames = (func) ->
  fnStr = func.toString().replace(STRIP_COMMENTS, "")
  result = fnStr.slice(fnStr.indexOf("(") + 1, fnStr.indexOf(")")).match(ARGUMENT_NAMES)
  result = [] if result is null
  result

###
returns a string representing the functions call signature
###
getSig = (fn, fnName='') ->
  if _.isFunction fn
    if fnName == ''
      fnName = getFnName fn
    params = getParamNames(fn)
    return "#{fnName}(#{params.join(', ')})"
  ''

###
document a function call signature all functions in a object and/or the call
signature of the object itself if it is a function
###
documentFuncs = (fnObj, fnObjName='') ->
  signitures = []
  if _.isFunction fnObj
    sigDocStr = getSig fnObj, fnObjName
    signitures.push sigDocStr
  if not _.isEmpty _.keys fnObj
    for k in _.keys fnObj
      v = fnObj[k]
      sigDocStr = getSig v, k
      if sigDocStr
        signitures.push sigDocStr
  signitures


doc = {getFnName, getParamNames, getSig, documentFuncs}

###
console.save - save a object to a json file
###
do (console) ->
  console.save = (data, filename) ->
    unless data
      console.error "Console.save: No data"
      return
    filename = "console.json"  unless filename
    data = JSON.stringify(data, `undefined`, 4)  if typeof data is "object"
    blob = new Blob([data],
      type: "text/json"
    )
    e = document.createEvent("MouseEvents")
    a = document.createElement("a")
    a.download = filename
    a.href = window.URL.createObjectURL(blob)
    a.dataset.downloadurl = [
      "text/json"
      a.download
      a.href
    ].join(":")
    e.initMouseEvent "click", true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null
    a.dispatchEvent e
    return

  return






