#!/usr/local/bin/node

// URL : http://gdata.youtube.com/feeds/api/users/USERNAME?v=2

var http = require("http"),
	parser = require('xml2json'),
	numeral = require('numeral'),
	config = require('./config.json'),
	username = config.user.username

var options = {
	host: 'gdata.youtube.com',
	port: 80,
	path: '/feeds/api/users/'+username+'?v=2'
};

numeral.language('fr', { delimiters: { thousands: '.', decimal: ',' }, abbreviations: { thousand: 'K', million: 'M', billion: 'B', trillion: 'T' }});
numeral.language('fr');

var xml = "";
var request = http.request(options, function(res) {
	res.setEncoding("utf8");
	res.on("data", function(chunk) {
		xml += chunk;
	});
	res.on("end", function() {
		var json = JSON.parse(parser.toJson(xml));
		var data = {'stats':{}};

		if (json.hasOwnProperty('errors')) {
			console.log('{"error":"'+json.errors.error.internalReason+'"}');
			return;
		}
		
		var statistics = json['entry']['yt:statistics'];
		var feedLink = json['entry']['gd:feedLink'];
		var subscribers = statistics.subscriberCount;

		data.stats.subscriberCount = (subscribers > 99999 )? numeral(subscribers).format('0.0a') : numeral(subscribers).format('0,0');
		data.stats.totalUploadViews = numeral(statistics.totalUploadViews).format('0,0');
		data.stats.total_uploads = 0;
		data.user = config.user;
		data.theme = config.theme;
		data.user.display_name = json['entry']['yt:username']['display']
		feedLink.forEach(function(el, index) {
			if (el['rel'] === 'http://gdata.youtube.com/schemas/2007#user.uploads') {
				data.stats.total_uploads = el.countHint;
			}
		});
		console.log(JSON.stringify(data));
	});
});
request.on('error', function(err) {
    console.log('{"error":"An error occured while connecting to the server."}');
});
request.end();