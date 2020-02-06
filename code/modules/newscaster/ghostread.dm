/mob/dead/observer/verb/read_news()
	var/datum/browser/popup = new(user, "ghost_news_list", 450, 600)
	popup.set_content(render_news_channel_list())
	popup.open()

/mob/dead/observer/Topic(href, href_list)
	. = ..()
	if(href_list["show_news_channel"])
		var/datum/D = locate(href_list["show_news_channel"])
		if(istype(D, /datum/news/feed_channel))		//safety
			render_news_channel(D)

/mob/dead/observer/proc/render_news_channel_list()
	var/datum/news_network = GLOB.news_network()
	var/list/content = list()
	for(var/i in news_network.network_channels)
		var/datum/news/feed_channel/FC = i
		content += "<b><a href='?_src_=[REF(src)];show_news_channel=[REF(FC)]'>[FC.name] ([length(FC.messages)] messages)[FC.locked? " (LOCKED)":""][FC.censored? " (CENSORED)":""][FC.is_admin_channel? " (ADMIN)":""]</a></b>"
	return content.Join("<br>")

/mob/dead/observer/proc/render_news_channel(datum/news/feed_channel/FC)
	var/list/content = list()
	content += "<B>[viewing_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[viewing_channel.returnAuthor(-1)]</FONT>\]</FONT><HR>"
	if(FC.censored)
		content += "<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a Nanotrasen D-Notice.<BR>"
		content += "No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
	if(!length(FC.messages))
	content += "<b>This channel is empty.<b><BR>"
		for(var/i in FC.messages)
			var/datum/feed_message/FM = i
			content += "-[FM.returnBody(-1)] <BR>"
			if(FM.img)
				src << browse_rsc(FM.img, "tmp_photo[i].png")
				content += "<img src='tmp_photo[i].png' width = '180'><BR>"
				if(FC.caption)
					content += "[FM.caption]<BR>"
				content += "<BR>"
			content += "<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[FM.returnAuthor(-1)] </FONT>\] - ([FM.time_stamp])</FONT><BR>"
			content += "<b><font size=1>[FM.comments.len] comment[FM.comments.len > 1 ? "s" : ""]</font></b><br>"
			for(var/i in FM.comments)
				var/datum/news/feed_comment/FC = i
				content += "<font size=1><small>[FC.body]</font><br><font size=1><small><small><small>[FC.author] [FC.time_stamp]</small></small></small></small></font><br>"
			if(FM.locked)
				content += "<b>Comments locked</b><br>"
	var/datum/browser/popup = new(src, "ghost_news_channel", 450, 900)
	popup.set_content(content.Join(""))
	popup.open()

