class AI extends BaseObject
	constructor: (@controller, @player) -> console.log @controller; @id = @controller.subscribe "tick", @handle; @controller.AI = @; @_stop = false
	handle: (formerplayer, override = false) =>
		table = @controller.model.table
		console.log "OVERRIDE", override
		return if ( formerplayer isnt @player * -1 ) and not override
		console.log formerplayer, @player, table
		
		AI=Math.floor(Math.random()*9)
		while table[AI] isnt 0 
			console.log table[AI], AI
			AI=Math.floor(Math.random()*9)
		@controller.tick {target: (jQuery "table##{@controller.uuid} #spot#{AI}")[0] }	
		
	allBlank: (table) =>
		ok = true
		for item in table
			if item isnt 0 then ok = false
		return ok
	detach: =>  @controller.unsubscribe "tick", @id
	reset: (@player) => 
		@id = @controller.subscribe "tick", @handle
		if @player is -1
			@controller.currentPlayer = 1
			@handle -1, true

module.exports = AI
