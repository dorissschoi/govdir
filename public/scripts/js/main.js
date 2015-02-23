requirejs.config({
	paths: {
		'cs': 'cs',
	    'coffee-script': 'coffee-script',
		'jquery': 'jquery',
		'underscore': 'underscore',
		'backbone': 'backbone',
		'backbone-pageable': 'backbone-pageable',
		'bootstrap': 'bootstrap'
	},
	shim: {
		'jquery': {
			exports: '$'
		},
		'underscore': {
			exports: '_'
		},
		'backbone': {
			deps: ['underscore', 'jquery'],
			exports: 'Backbone'
		},
		'bootstrap': ['jquery']
	}
});

define(['cs!../coffee/app', 'bootstrap'], function(app) {
	console.log(app);
	ContactApp = new app.ContactApp();
});