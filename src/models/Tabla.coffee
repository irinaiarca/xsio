_solve = [
	[0, 1, 2], [0, 3, 6], [0, 4, 8], [2, 5, 8], [6, 7, 8], [2, 4, 6], [3, 4, 5], [1, 4, 7]
]

class ModelDeTable extends BaseObject
	constructor: () -> do @reset
		
	# Tick a square of the game table : X or 0
	# @param [Number] who The player that ticked it, aka -1 or 1 (1 is X, -1 is 0)
	# @param [Number] spot The spot on the table (interval [0..8])
	tick: (who, spot) => 
	
		# Error Handling
		if not spot in [0..8] then return throw ER.generate 1
		if @table[spot] isnt 0 then return throw ER.generate 2
		
		# Actual stuff ffs
		@table[spot] = who
		status = do @check
		if status then @reset status
		
	reset: (success = false) =>
		@table = [0, 0, 0, 0, 0, 0, 0, 0, 0]
		if success then @done success
	
	# Checks wether the table is complete (someone won ffs)
	check: () =>
		for solution in _solve
			for x in solution
				if not @table[x] in [-1..1] then throw ER.generate 3
			if @table[solution[0]] is @table[solution[1]] and @table[solution[1]] is @table[solution[2]] and @table[solution[0]] in [-1, 1] then return @table[solution[0]]

		nr = 0
		for index in [0..8] 
			if @table[index] then nr++
		if nr is 9 then return 2
		return 0

class ModelDeTableErrorReporter extends BaseObject

	@errors:
		"TickError": [
			"Out of bounds"
			"Already ticked"
		]
		"CheckError": [
			"Wtf is this?"
		]

	@extend IS.ErrorReporter

ER = ModelDeTableErrorReporter
module.exports = ModelDeTable