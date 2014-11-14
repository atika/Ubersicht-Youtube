# Ubersicht Youtube widget
# Display public statistics of a Youtube User
# Change the path to the script below and play with the configuration file (config.json)
# Dominique Da Silva / Nov 2014

command: "/usr/local/bin/node /Full/Path/To/Folder/Commands/Youtube.command/youtube.js"

refreshFrequency: 3600000 #every hours

render: -> """
		<div class="icon"></div>
		<a href="https://www.youtube.com" class="ytlink">Youtube</a>
		<div class="subscribers"></div>
		<div class="stats">
			<span class="views"></span><br>
			<span class="total"></span>
		</div>	
"""

style: """

	width: 280px
	height: 55px
	font-family: Helvetica Neue
	font-size: 13px
	color: #FFF
	padding:15px 0px

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
		top: 37px
		.views
			font-size:1.2em
			opacity: 0.3
			color: #FFF
			line-height:1.3em
	.icon
		width: 50px
		height: 35px
		background: url(Youtube.widget/icon.png) no-repeat
		background-size: 50%;
		position: absolute
		left: 120px
		opacity:0.1

	a.ytlink
		text-decoration: none
		color: #FFF
		opacity: 0.1
		position: absolute
		top: 17px
		left: 151px

	a.ytlink:hover
		color:#FFF

"""

lang: 
	"US":
		subscribers:"subscribers"
		views:"views"
		videos:"videos"
	"FR":
		subscribers:"abonnés"
		views:"vues"
		videos:"vidéos"


update: (output, domEl) ->
	youtube = JSON.parse(output)

	if youtube.error
		$(domEl).html(youtube.error)
	else
		language = @lang[youtube.user.lang];
		position = youtube.theme.position.split("|")

		# Theme
		switch position[0]
			when "TL"
				$(domEl).css({'left':parseInt(position[1]),'top':parseInt(position[2])})
			when "TR"
				$(domEl).css({'right':parseInt(position[1]),'top':parseInt(position[2])})
			when "BR"
				$(domEl).css({'right':parseInt(position[1]),'bottom':parseInt(position[2])})
			when "C"
				$(domEl).css({'left':$(window).width()/2-$(domEl).width()/2,'top':$(window).height()/2-50})
			else
				$(domEl).css({'left':parseInt(position[1]),'bottom':parseInt(position[2])})
		
		$(domEl).css('background-color',youtube.theme.backcolor) if youtube.theme.backcolor != ''

		# Populate
		$(domEl).find('.subscribers').animate({'opacity':0.3},500).html(youtube.stats.subscriberCount + ' <span class="label">'+language.subscribers+'</span>').animate({'opacity':1},500)
		$(domEl).find('.stats .views').animate({'opacity':0.3},500).delay(150).html(youtube.stats.totalUploadViews+' '+language.views).animate({'opacity':1},500)
		$(domEl).find('.stats .total').html(youtube.stats.total_uploads+' '+language.videos)
		$(domEl).find('.ytlink').attr('href', 'https://www.youtube.com/user/'+youtube.user.username)
		$(domEl).find('.ytlink').html(youtube.user.display_name) if youtube.user.show_name

		$('.icon, .ytlink').animate
			'opacity':1.0
			500
		.delay(500).animate 
			'opacity':youtube.theme.logo_opacity
			250
