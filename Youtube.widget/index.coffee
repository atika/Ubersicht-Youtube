# Ubersicht Youtube widget
# Display public statistics of a Youtube User Channel
# Change the path to the script below and play with the commandline utility parameters
# Dominique Da Silva / Nov 2014

# 2018 Dec - Added support for Youtube API v3 (cli app written in Go lang)
# 2014 Nov - A NodeJS app get the stats from a public Youtube feed page

{

command: """/path/to/ubersicht-youtube -key="XXXXXX" -username="channelname" -position="BL|20|120" -lang="FR" -showname -logored """

refreshFrequency: 3600000 #every hours

render: -> """
		<div class="icon"></div>
		<a href="https://www.youtube.com" class="name">Youtube</a>
		<div class="subscribers"></div>
		<div class="stats">
			<span class="views"> </span><br>
			<span class="uploads"> </span>
		</div>
"""

style: """
	width: 290px
	height: 55px
	font-family: Helvetica Neue
	font-size: 13px
	color: #FFF
	padding:15px 0px
	border-radius: 6px

	.subscribers
		width: 100px
		height: 100%
		font-size:30px
		line-height:24px
		text-align:right
		padding-right: 10px
		padding-top: 5px
		border-right: solid 1px rgba(255,255,255,0.2)

		.label
			display: block
			//position: absolute
			color:rgba(255,255,255,0.3)
			font-size:12px
	.stats
		position: absolute
		width: 150px
		left: 120px
		color:rgba(255,255,255,0.3)
		top: 35px
		.views
			width: 100%
			height: 25px
			display: inline-block
			white-space: nowrap
			font-size: 1.2em
			opacity: 0.3
			color: #FFF
			line-height:1.3em
			span
				margin: auto
			b
				margin: auto
				font-size: 0.8em
	.icon
		width: 50px
		height: 35px
		background: url(Youtube.widget/icon.png) no-repeat
		background-size: 50%;
		position: absolute
		left: 120px
		opacity:0.1

	.icon.red
		background: url(Youtube.widget/icon-red.png) no-repeat
		background-size: 50%;

	.error
		color: red

	a.name
		text-decoration: none
		color: #FFF
		opacity: 0.1
		position: absolute
		top: 16px
		left: 151px

	a.name:hover
		color:red
"""

lang: {
	US: {
		subscribers: "subscribers"
		views: "views"
		videos: "videos"
	},
	FR: {
		subscribers: "abonnés"
		views: "vues"
		videos: "vidéos"
	},
	PT: {
		subscribers: "subscritores"
		views: "visualizações"
		videos: "vídeos"
	}
}

toggleView: (m, domEl) ->

		language = m.lang[m.youtube.theme.lang] || m.lang['US']
		if m.timer
			clearTimeout m.timer
			m.timer = undefined

		if m.t
			ct = '<span>' + m.youtube.statsf.subscribers2 + '</span> <b>' + language.subscribers + '</b>'
			delay = 10000
		else
			ct = '<span>' + m.youtube.statsf.views + '</span> <b>' + language.views + '</b>'
			delay = 40000

		m.t = !m.t

		# Animate
		st = $(domEl).find('.stats .views')
		st.stop(true, true).animate { 'opacity': 0.0 }, 350, () ->
			st.html(ct)
		.delay(100).animate({ 'opacity': 1.0 }, 1000)

		m.timer = setTimeout m.toggleView, delay, m, domEl


update: (output, domEl) ->

	m = @

	try
		@youtube = JSON.parse(output)
	catch e
		return $(domEl).html("<b class=\"error\">YouTube Widget</b>: " + e)

	language = @lang[@youtube.theme.lang] || @lang['US']
	position = @youtube.theme.position.split("|")

	if @timer
		clearTimeout @timer
		@timer = undefined
		@t = false

	# Theme
	switch position[0]
		when "TL"
			$(domEl).css({ 'left': parseInt(position[1]), 'top': parseInt(position[2]) })
		when "TR"
			$(domEl).css({ 'right': parseInt(position[1]), 'top': parseInt(position[2]) })
		when "BR"
			$(domEl).css({ 'right': parseInt(position[1]), 'bottom': parseInt(position[2]) })
		when "C"
			ww = $(window).width()
			wdw = $(domEl).width()
			wdh = $(window).height()
			$(domEl).css({ 'left': (ww / 2) - (wdw / 2), 'top': (wdh / 2 - 50) })
		else
			$(domEl).css({ 'left': parseInt(position[1]), 'bottom': parseInt(position[2]) })

	$(domEl).css('background-color', @youtube.theme.back_color) if @youtube.theme.back_color != ''

	if @youtube.error
		return $(domEl).html("<b class=\"error\">YouTube Widget Error</b><br>" + @youtube.error)

	# Populate and animate
	$(domEl).find('.subscribers')
		.animate { 'opacity': 0.4 }, 400
		.html @youtube.statsf.subscribers + ' <span class="label">' + language.subscribers + '</span>'
		.animate { 'opacity': 1 }, 300

	@toggleView(@, domEl)

	$(domEl).find('.icon').addClass('red')  if @youtube.theme.logo_red
	$(domEl).find('.uploads').html @youtube.statsf.uploads + ' ' + language.videos
	$(domEl).find('.name').attr 'href', 'https://www.youtube.com/user/' + @youtube.user
	$(domEl).find('.name').html(@youtube.displayname) if @youtube.theme.show_name

	$(domEl).find('.icon, .name')
		.animate { 'opacity': 1.0 }, 500
		.delay(500).animate { 'opacity': @youtube.theme.logo_alpha }, 250

	$(domEl).find('.stats').on 'click', () ->
		m.toggleView m, domEl

}
