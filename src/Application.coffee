require "Object"
class Application extends BaseObject

	constructor: (message) ->

		root = window
		root.echo = ( require "Object" ).echo
		document.title = "X si O"

		root.DepMan = new ( require "helpers/DependenciesManager" )
		root.LinkManager = new (DepMan.helper "LinkManager")

		# FontAwesome
		DepMan.stylesheet "font-awesome"
		
		# jQuery
		DepMan.lib "jquery"

		# Fonts
		DepMan.googleFont "Electrolize", [400]
		DepMan.googleFont "Open Sans", [400], ["latin", "latin-ext"]
		DepMan.googleFont "Just Me Again Down Here", [400]

		_login = =>
			if localStorage.getItem "login" then return LinkManager.checkRoute "/index"
			document.getElementsByTagName("form")[0].addEventListener "submit", (e) ->
				localStorage.setItem "login", e.target.children[0].value
				LinkManager.checkRoute "/index"
				do e.preventDefault

		# Routes
		items = [
			{
				link: "/login"
				handler: _login
			}
			{link: "/help"}
			{link: "/bonus"}
			{link: "/bonus2"}
			{link: "/bonus3"}
			{link: "/bonus4"}
			{link: "/index"}
			{link: "/story/choice"}
			{link: "/story/blue"}
			{link: "/story/pink"}
			{link: "/story/draw"}
			{link: "/story/blue/win"}
			{link: "/story/blue/lose"}
			{link: "/story/pink/win"}
			{link: "/story/pink/lose"}

		]

		routes =
			"/": -> document.body.innerHTML = DepMan.render "login"; do _login
			"/logout": -> localStorage.removeItem "login"; LinkManager.checkRoute "/"
			"/2pgame": -> document.body.innerHTML = "<section></section>"; new (DepMan.controller "Tabla")(); do renderLogout
			"/casual": -> document.body.innerHTML = "<section></section>"; x = new (DepMan.controller "Tabla")(); y = new (DepMan.helper "AI")(x, 1); do renderLogout
			"/story/blue/game": -> document.body.innerHTML = "<section></section>"; new (DepMan.helper "Runner")(1); do renderLogout
			"/story/pink/game": -> document.body.innerHTML = "<section></section>"; new (DepMan.helper "Runner")(-1); do renderLogout
			
		root.gButton = (link, text, id = "", stilizat = false) -> "<a class='fancyfont#{if stilizat then " button" else ""}' id='#{id}' href='#{link}'>#{text}</a>"
		
		renderLogout = ->
			if not document.getElementById("admin")? then do ->
				w = document.createElement "div"
				w.setAttribute "id", "admin"
				n = document.createElement "span"
				n.innerHTML = localStorage.getItem "login"
				w.appendChild n
				n = document.createElement "a"
				n.setAttribute "href", "/logout"
				n.setAttribute "class", "fancyfont"
				n.innerHTML = "Logout"
				w.appendChild n
				document.body.appendChild w

		renderDoc = (doc) ->
			if document.getElementsByTagName("section").length is 0 then document.body.innerHTML = "<section></section>"
			do renderLogout
			document.querySelector("section").innerHTML = DepMan.render doc
			do LinkManager.linkAllAnchors

		for item in items
			if item.link isnt "/"
				routes[item.link] = do(item) => =>
					if item.link isnt "/login" and !localStorage.getItem("login") then return LinkManager.checkRoute "/"
					args = [ item.link.substr 1 ]
					if item.replacePlaceHolder? then args.push true
					if item.after? then args.push item.after
					renderDoc.apply renderDoc, args
					true

		root.LinkManager.setRoutes routes
		do root.LinkManager.linkAllAnchors

module.exports = Application

