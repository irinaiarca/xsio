require "Object"
class Application extends BaseObject

	constructor: (message) ->

		root = window
		root.echo = ( require "Object" ).echo
		document.title = "X si 0"

		root.DepMan = new ( require "helpers/DependenciesManager" )
		root.LinkManager = new (DepMan.helper "LinkManager")

		# FontAwesome
		DepMan.stylesheet "font-awesome"

		# Fonts
		DepMan.googleFont "Electrolize", [400]
		DepMan.googleFont "Open Sans", [400], ["latin", "latin-ext"]
		DepMan.googleFont "Just Me Again Down Here", [400]

		# Routes
		items = [
			{link: "/login"}
			{link: "/help"}
			{link: "/bonus"}
			{link: "/about"}
			{link: "/index"}
		]

		routes =
			"/": -> document.body.innerHTML = DepMan.render "login"

		renderDoc = (doc) ->
			document.querySelector("body").innerHTML = DepMan.render doc
			do LinkManager.linkAllAnchors

		for item in items
			if item.link isnt "/"
				routes[item.link] = do(item) => =>
					args = [ item.link.substr 1 ]
					if item.replacePlaceHolder? then args.push true
					if item.after? then args.push item.after
					renderDoc.apply renderDoc, args
					true

		root.LinkManager.setRoutes routes
		do root.LinkManager.linkAllAnchors

module.exports = Application

