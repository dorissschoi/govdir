define ['backbone', 'cs!../coffee/view' ], (Backbone, View) ->
	class AppRouter extends Backbone.Router
		routes:
			'*path':		'list'
			
			
		constructor: () ->
			super()
			@mainview = new View.MainView({el: 'body'})
			@mainview.render()
			@on 'all', (eventName) -> 
				console.log eventName + ' was triggered!'
			
	return { 'AppRouter': AppRouter }