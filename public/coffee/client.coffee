node = DNode
  # emit: ->
  #   emitter.emit.apply emitter, arguments
  log: (message) ->
    console.log message

node.connect (remote, connection) ->
  init(remote, connection)  
  
  
init = (remote, connection) ->
  # backbone sync
  Backbone.sync = (method, model, options) ->
    remote.sync method, model.col, model.attributes, (documents) ->
      options.success documents


  Message = Backbone.Model.extend {}
  Messages = Backbone.Collection.extend
    model: Message
    col: 'messages'
    
      
  messages = new Messages
  
  MessageView = Backbone.View.extend
    events:
      "submit #chatForm" : "handleNewMessage"
      "click #refresh" : "refresh"
      
    refresh: () ->
      
      
    handleNewMessage: (data) ->
      inputField = $('input[name=newMessageString]')
      messages.create
        content: inputField.val()
        collection: 'solutions'
      inputField.val ''

    render: ->
      data = messages.map (message) ->
        console.log message
        return message.get('content') + '\n'
      result = data.reduce (memo, str) ->
        return memo + str
      $('#chatHistory').text result
      @handleEvents
      return this
      
  view = new MessageView
    el: $('#chatArea')