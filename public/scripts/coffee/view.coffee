define ['jquery', 'underscore', 'backbone', 'cs!../coffee/model', 'backbone.wreqr', 'backbone.marionette'], ($, _, Backbone, model, wreqr, Marionette) ->
	
	vent = new Backbone.Wreqr.EventAggregator()
	
	class MainView extends Backbone.Marionette.LayoutView
		
		template: (data) ->
			"""
				<div class="container">
					<div id="nonmobilestyle">
					<div class="row">
						<div class="col-xs-12 col-md-4" id="contactList">
							<div id="searchregion" class="col-xs-12 col-md-4 "></div>
							<div id="listregion" class="col-xs-12 col-md-4"></div>
						</div>	
						<div class="col-xs-8 col-md-8" id="contactDetail" >
							<div id="detailregion" class=""></div>
						</div>
					</div>
					</div>
				</div>			
			"""

		regions:  
			searchregion:	"#searchregion"
			listregion:		"#listregion"
			detailregion:	"#detailregion"

		constructor: (options = {}) ->
			super(options)
			detail = new DetailView()
			
			vent.on 'change:selected', (contact) =>
				detail.model = contact
				@detailregion.show(detail, {forceShow: true})
								
		onRender: () ->
			@searchregion.show(new SearchView())
			@listregion.show(new ListView({collection: new model.ContactList()}))
		
			
			
	class SearchView extends Backbone.Marionette.ItemView
		className:	"input-group"
		
		id:			"search"
						
		template: (data) ->
			"""
				<span class="input-group-addon input-group  "> 
					<i class="glyphicon glyphicon-search"></i>
				</span> 
				<input id="searchInput" type='text' class="form-control" placeholder='Name...'>
			"""
			
		events:
			'input #searchInput':	'search'
		
		search: ->
			vent.trigger 'pattern:change', $("#searchInput").val()

		
	class ListView extends Backbone.Marionette.ItemView
		template: (data) =>
			tmpl = """
				<div class="panel-group" id="accordion">
				
			
					<% var i=1;%>
					<% _.each(obj.models, function(contact) { %>
						<div class="panel panel-default">
						<div class="panel-heading">
							<h4 class="panel-title">
							<ul class="nav">
								<li id="<%= contact.id %>" class="showDetail">
								<a class="accordion-toggle rec-<%=i %>" data-toggle="collapse" 
								data-parent="#accordion" href="#collapse_<%=i %>">
								<%= contact.get('name') %> - <%= contact.get('title') %>
								</a></li>
							</ul>
							</h4>
						</div>
						<div id="collapse_<%=i %>" class="panel-collapse collapse d-<%= contact.id %>">
						<div class="panel-body">
							
							<i class="glyphicon glyphicon-earphone"></i> : <a href="tel:<%= contact.get('phone') %>"><%= contact.get('phone') %></a></br>
							<i class="glyphicon glyphicon-envelope"></i> : <a href="mailto:<%= contact.get('email') %>"><%= contact.get('email') %></a>
					
						</div>	<!--panel-body-->
						</div>	<!--panel-collapse-->
						</div>	<!--panel-default-->	
					<% i++; %>					
					<% }); %>
				
				</div>	<!--panel-->			
			"""
			_.template tmpl, @collection

		collectionEvents:
			'reset':	'render' 			

		events:
			'click li.showDetail':	'select'

		constructor: (options = {}) ->
			super(options)
			@collection.fetch
				reset:	true		
			vent.on 'pattern:change', (searchInput) =>
				@collection.fetch
					data:
						search_input:	searchInput
					reset:	true
			$(window).on "resize", @updateCSS
		
		updateCSS: () ->
			bodyheight = $(document).height()
			$("#listregion").height(bodyheight*0.9)
					
		select: (e) ->
			selDetail = @collection.findWhere _id: $(e.currentTarget).attr('id')
			@$('li').removeClass("highlight")
			$(e.currentTarget).addClass("highlight")
			$('div[id^="collapse_"]').css("display","none")
			selID = $(e.currentTarget).attr('id')
			if $("#contactDetail").is(':visible')
				$('.d-' + selID).css("display","none")
			else
				$('.d-' + selID).css("display","block")
			vent.trigger 'change:selected', selDetail
						
		onRender: () ->
			bodyheight = $(document).height()
			$("#listregion").height(bodyheight*0.9)
			#$('#listregion:first .nav li a').trigger("click")
			$('.rec-1').trigger("click")


			
	class DetailView extends Backbone.Marionette.ItemView
		template: (data) =>
			tmpl = """
				<h2><%= obj.get('name') %> - <%= obj.get('title') %></h2></br>
				<table class="table">
					<thead>
						<tr><th><i class="glyphicon glyphicon-earphone"></i> Office tel</th></tr>
					</thead>
					<tbody>
						<tr><td><a href="tel:<%= obj.get('phone') %>"><%= obj.get('phone') %></a></td>
					</tr></tbody>
				</table>
				<table class="table">
					<thead>
						<tr><th><i class="glyphicon glyphicon-envelope"></i> Email</th></tr>
					</thead>
					<tbody>
						<tr><td><a href="mailto:<%= obj.get('email') %>"><%= obj.get('email') %></a></td>
					</tr></tbody>
				</table>
			"""
			_.template tmpl, @model

		
																
		
	return 'DetailView': DetailView, 'MainView': MainView  