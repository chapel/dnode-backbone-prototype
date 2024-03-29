doctype 5
html lang: 'en', ->
  head ->
    meta charset: 'utf-8'
    meta 'http-equiv': 'Content-Type', content: 'text/html; charset: utf-8'
    title 'nodehub'
    
    # styles
    link type: 'text/css', rel: 'stylesheet/less', href: '/less/master.less'
    
    # deps
    script type: 'text/javascript', src: '/vendor/cloudhead/less.js/dist/less-1.0.41.js'
    script src: 'http://code.jquery.com/jquery-1.4.4.js', type: 'text/javascript'
    script src: '/dnode.js', type: 'text/javascript'
    script src: '/vendor/jashkenas/coffee-script/extras/coffee-script.js', type: 'text/javascript'
    script src: 'http://documentcloud.github.com/underscore/underscore.js', type: 'text/javascript'
    script src: 'http://documentcloud.github.com/backbone/backbone.js', type: 'text/javascript'
    
    script src: '/coffee/require.coffee', type: 'text/coffeescript'
    
    # client
    script src: '/coffee/client.coffee', type: 'text/coffeescript'

  body ->
    div id: 'chatArea', ->
      textarea id: 'chatHistory'
      form method: 'post', action: '#', id: 'chatForm', name: 'newMessage', onsubmit: 'return false', ->
        input name: 'newMessageString', type: 'text'
        input type: 'submit', value: 'send'
      a href: '#', id: 'refresh', -> 'Refresh'
      