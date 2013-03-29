_first = true
class LinkManager extends BaseObject

	constructor: (@history = [], @routes = []) -> window.addEventListener "popstate", ( (e) => if _first then return _first = false; else do @checkRoute); @echo "LinkManager Activated!"
	setRoutes: (routePatterns) =>
		for route, handler of routePatterns
			@routes.push route: route, handler: handler
		do @checkRoute
			
	checkRoute: (after = "") =>
		if after[0] is "/" then loc = after
		else loc = window.location.pathname + after
		_baseLoc = loc
		loc = loc.substr 0, loc.length - 1 if loc[loc.length - 1] is "/"
		_loc = loc
		for routeSet in @routes
			loc = _loc.split "/"

			route = routeSet.route
			route = route.substr 0, route.length - 1 if route[route.length - 1] is "/"
			route = route.split "/"

			args = []

			res = true
			while route.length and res
				r = do route.shift
				l = do loc.shift
				if r[0] is ":" then args[r.substr 1] = l
				else
					if r isnt l then res = false
			id = _baseLoc.substr 1
			if id is "" then id = "index"
			if res and loc.length is 0 then document.body.setAttribute("id", id); return routeSet.handler args
			else continue
		document.body.innerHTML = DepMan.render 404, title: "Bullshit?", text: "404", reason: "This page either does not exist, or it is hidden.", message: """
				Why would it be hidden? Well, monkeys are always rapaging through the labs, and sometimes want to play hide and seek with our pages.

				That, or  you don't have permission to view those files.
		"""
		do @linkAllAnchors
		return false

			
	
	link: (e) =>
		if e.substr? then link = e
		else 
			el = @getParentAnchor e.srcElement
			link = el.getAttribute "href"
		if @checkRoute(link) then history.pushState null, null, link
		e.preventDefault()

	getParentAnchor: (e) =>
		return null if not e?
		if e.tagName is "A" then return e
		return @getParentAnchor e.parentNode

	linkAllAnchors: =>
		anchors = document.querySelectorAll("a")
		anchor.addEventListener "click", @link for anchor in anchors

class LinkErrorReporter extends IS.Object

	@errorGroups = []
	@errorGroupMap = []
	@errorMessages = []

	@extend IS.ErrorReporter


module.exports = LinkManager
