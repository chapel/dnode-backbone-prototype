path = require 'path'

dnode = require 'dnode'
connect = require 'connect'

server = connect.createServer()
server.use connect.staticProvider(path.join(__dirname, '/public'))

###
CLIENT
###
handler = (client, connection) ->  
  @log = (data) ->
    console.log data
  
  return

node = dnode handler
node.listen server

server.listen 1337
console.log 'http://localhost:1337/'