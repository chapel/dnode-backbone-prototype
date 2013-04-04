path = require 'path'
coffeekup = require 'coffeekup'
dnode = require 'dnode'
connect = require 'connect'
fs = require 'fs'
Database = require './database'

db = new Database.connect
  host: 'localhost'
  port: 5984
  path: '/nodehub'
  
server = connect.createServer()
server.use connect.staticProvider(path.join(__dirname, '/public'))
server.use connect.router (app) ->
  app.get '/', (req, res) ->
    fs.readFile 'public/index.coffee', (err, data) ->
      console.log err if err?
      res.writeHead '200'
      res.end coffeekup.render data.toString()


###
CLIENT
###
handler = (client, connection) ->
  @log = (data, cb) ->
    console.log data
    client.log 'pong'

  @sync = (args...) ->
    [action, model, options, callback] = args
    
    console.log model.toString(), options
    ###
    switch action
      when 'read'
        
  
        
      when 'update'
        
      
      when 'create'
        
      
      when 'delete'
      ###
  return

node = dnode handler
node.listen server

server.listen 1337
console.log 'http://localhost:1337/'