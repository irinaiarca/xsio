class AI extends BaseObject
	constructor: (@controller, @player) -> console.log @controller; @id = @controller.subscribe "tick", @handle
	handle: (formerplayer) =>
		table = @controller.model.table
		return if @offline?
		return if formerplayer isnt @player * -1
		console.log formerplayer, @player, table
		
		AI=Math.floor(Math.random()*9)
		while table[AI] isnt 0 
			console.log table[AI], AI
			AI=Math.floor(Math.random()*9)
		@controller.tick {target: document.getElementById "spot#{AI}" }	
		
	detach: =>  @controller.unsubscribe "tick", @id

module.exports = AI