env = require 'govdirenv'
mongoose = require 'mongoose'
model = require './model'


index = (req, res) ->
	res.render 'index', title: 'Contact'
	
	
all = (req, res) ->
  model.userModel.find (err, resource) ->
        res.send resource
				    
#page start from 1 base
class ListView
	constructor: (@page_size = env.page_size, @page = env.page) ->

	get_page: () ->
		return if @page < 1 then 0 else @page - 1
		
		
	query: () ->
		return model.userModel.find({}).sort({name: 1}).limit(@page_size).skip(@get_page() * @page_size)
		
	query2: (name) ->
		return model.userModel.find({name: new RegExp(name, 'i') }).sort({name: 1}).limit(@page_size).skip(@get_page() * @page_size)
	
	# use fat arrow, please see http://coffeescript.org/
	as_view: (req, res) =>
		@page_size = (Number) req.query.page_size ? env.page_size
		@page = (Number) req.query.page ? env.page
		console.log req.query
		
		@search_input = req.query.search_input
		if req.query.search_input
		  @query2(req.query.search_input).exec (err, coll) =>
			  if err
				  throw err
			  model.userModel.count {name: new RegExp(req.query.search_input, 'i')}, (err, count) =>
				  if err
					  throw err
				  res.send([{'count': count}, coll])		  
		else
		  @query().exec (err, coll) =>
			  if err
				  throw err
			  model.userModel.count {}, (err, count) =>
				  if err
					  throw err
				  res.send([{'count': count}, coll])  
				    
module.exports = 'all': all,'ListView': new ListView(), 'index': index