define ['backbone', 'backbone-pageable'], (Backbone, PageableCollection) ->
	Backbone.PageableCollection = PageableCollection
	
	class Contact extends Backbone.Model
		idAttribute: "_id"
		
		url: (id) -> "/contact/read/[id]"
	
	
	class ContactList extends Backbone.PageableCollection
		model:	Contact
		url:	'/govdir/api/contact/'  
			
		state:
			firstPage: 1
			pageSize: 1000

		queryParams:
			currentPage: 'page'
			pageSize: 'page_size'
			totalRecords: 'count'
		
		constructor: () ->
			@on("all", (eventName) -> 
				console.log eventName + ' was triggered!')
			@searchInput=""	
			super()
		
		setSearchInput: (searchInput) ->
		 	@searchInput = searchInput	
		
				
	return 'Contact': Contact, 'ContactList': ContactList