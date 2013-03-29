class Enum

	constructor: (items) ->
		@[item] = key for item, key in items
		
module.exports = Enum