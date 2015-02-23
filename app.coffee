mongoose = require 'mongoose'
express = require 'express'
http = require 'http'
path = require 'path'
view = require './view'
env = require 'govdirenv'
batchjob = require './getData/batchjob' 

app = express()

# all environments
app.set 'port', env.PORT or 8005
app.set 'views', __dirname + '/template'
app.set 'view engine', 'jade'
app.use (req, res, next) ->
	p = new RegExp('^' + env.path)
	req.url = req.url.replace(p, '')
	next()
app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))

# development only
app.use express.errorHandler()  if 'development' is app.get('env')

	
app.get '/',                 				view.index
app.get '/api/contact/:search_input?',      view.ListView.as_view	


http.createServer(app).listen app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port'))
