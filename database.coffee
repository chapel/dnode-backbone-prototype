http = require 'http'

clone = (obj) ->
   clone = {}
   for i of obj
     clone[i] = if obj[i] instanceof Object then @clone(obj[i]) else obj[i]
   return clone
   
newId = (len, radix) ->
  chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_'.split ''
  newId = []
  
  radix = radix or chars.length
  len = len or 22
  
  newId[i] = chars[0 | Math.random()*radix] for i in [0..len]
  
  return newId.join ''
  

class exports.connect
  constructor: (@options) ->
  
  that = this
  
  @request = (options, model, cb) ->
    if typeof cb is 'undefined'
      cb = model
      chk = true
    options.method = 'GET' if typeof options.method is 'undefined'
    req = http.request options, (res) ->
      result = ''
      res.on 'data', (chunk) ->
        result += chunk
      res.on 'end', ->
        cb JSON.parse result
    req.write model unless chk is true
    req.end()
    
  @getRev = (options, cb) ->
    that.request options, (results) ->
      results = JSON.parse results
      cb results._rev
  
  create: (model, cb) ->
    model.created = new Date
    model.id = newId 8
    modelJSON = JSON.stringify model
    options = clone @options
    options.path = options.path + '/' + model.id
    options.method = 'PUT'
    options.headers = 
      'Content-Length': modelJSON.length
      'Content-Type': 'application/json'
    that.request options, modelJSON, (res) ->
      if res then success res
      else error res
    
  update: (model, cb) ->
    options = clone @options
    options.path = options.path + '/' + model.id
    that.getRev options, (rev) ->
      model._id = model.id
      model._rev = rev
      modelJSON = JSON.stringify model
      options.method = 'PUT'
      options.headers = 
        'Content-Length': modelJSON.length
        'Content-Type': 'application/json'
      that.request options, modelJSON, (res) ->
        if res then success res
        else error res
  
  find: (model, cb) ->
    options = clone @options
    options.path = options.path + '/' + model.id
    that.request options, (res) ->
      if res then cb null, res
      else cb res
        
  all: (col, cb) ->
    console.log col
    options = clone @options
    options.path = options.path + '/_design/store/_view/all?key="' + col + '"'
    options.method = 'GET'
    that.request options, (res) ->
      if res.rows.length > 0
        arr = []
        curr = {}
        model = {}
        for i of res.rows
          curr = res.rows[i]
          model.id = curr.id unless model.id
          arr.push model
        success arr
      else
        error res
        
  
  delete: (model, cb) ->
    options = clone @options
    options.path = options.path + '/' + model.id
    that.getRev options, (rev) ->
      options.path = options.path + '?rev=' + rev
      options.method = 'DELETE'
      that.request options, (res) ->
        if res then success res
        else error res
  