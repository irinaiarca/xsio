class Runner extends BaseObject

	constructor: (@character) -> do @play
	play: =>
		console.log "Playing with #{@character}"
		x = new (DepMan.controller "Tabla")()
		y = new (DepMan.helper "AI")(x, @character)
		y.handle 1 if @character is -1
		x.model.done = (cine1) =>
				do y.detach
				console.log "Level 1, result : #{cine1}"
				if cine1 is 2 then do @draw
				else 
					document.body.innerHTML = "<section></section>"
					x = new (DepMan.controller "Tabla")()
					y = new (DepMan.helper "AI")(x, @character)
					y.handle 1 if @character is -1
					x.model.done = (cine2) =>
						do y.detach
						console.log "Level 2, results : #{cine1}, #{cine2}"
						document.body.innerHTML = "<section></section>"
						if cine2 is 2 then do @draw
						else if cine1 is cine2 
							if cine1 is @character then do @win
							else do @lose
						else
							document.body.innerHTML = "<section></section>"
							x = new (DepMan.controller "Tabla")()
							y = new (DepMan.helper "AI")(x, @character)
							y.handle 1 if @character is -1
							x.model.done = (cine3) =>
								do y.detach
								console.log "Level 3, result : #{cine3}"
								if cine3 is 2 then do @draw
								else if cine1 is cine3 
									if cine3 is @character then do @win
									else do @lose
								else if cine2 is cine3
									if cine3 is @character the do @win
									else do @lose
		@
								
	lose: => LinkManager.link "/story/#{do @which}/lose"
	win: => console.log "#{do @which} Won"; LinkManager.link "/story/#{do @which}/win"	
	draw: => LinkManager.link "/story/draw"
	
	which: => if @character is 1 then return "blue" else return "pink"
		

module.exports = Runner