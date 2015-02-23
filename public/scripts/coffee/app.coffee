define ['backbone', 'cs!../coffee/router'], (Backbone, router) ->
	class ContactApp
		constructor: () ->
			appRouter = new router.AppRouter()
			Backbone.history.start()
			appRouter.on 'all', (eventName) -> 
				console.log eventName + ' was triggered!'
		
	return 'ContactApp': ContactApp