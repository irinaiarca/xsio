class TableController extends BaseObject
		
	@include IS.Modules.Observer

	constructor: () ->
		@queue = {}
		@model = new (DepMan.model "Tabla")()
		@model.done = @done
		$("section").html DepMan.render "tabla"
		@view = $("section table")
		console.log @view
		@spots = @view.find("td")
		@currentPlayer = 1
		@_reset = false
		for kid in @spots
			kid.addEventListener "click", @tick 
			
			
	tick : (e) => 
		try 
			@model.tick @currentPlayer, e.target.id.replace "spot", ""
			if @_reset then @_reset = false
			else 
				e.target.innerHTML = do @player
				@currentPlayer *= -1
				@publish "tick", @currentPlayer
		catch e
			switch e.errCode
				when 1 then alert "Faci ceva dubios pe-aci!?"
				when 2 then alert "Ai dat deja aci"
			
	done: => @queue = []; @reset.apply @, arguments

	player: => 			
		switch @currentPlayer
			when 1 then return "X"
			when -1 then return "O"

	reset: (kind = 0) => 
		console.log "RESETTING"
		if kind is 2 then alert "Egal!"
		else alert "A câștigat #{do @player}"
		for kid in @spots then kid.innerHTML = ""
		@currentPlayer *= -1
		@AI.reset @currentPlayer if @AI?
		@_reset = true
		

class TableControllerErrorReporter extends BaseObject

	@errors: 
		"Bullshit": []

	@extend IS.ErrorReporter

ER = TableControllerErrorReporter
module.exports = TableController
