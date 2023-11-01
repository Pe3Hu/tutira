extends MarginContainer


@onready var basic = $Impules/Basic
@onready var bonus = $Impules/Bonus

var flow = null
var satellite = null
var type = null
var subtype = null
var impulse = 0


func set_attributes(input_: Dictionary) -> void:
	flow = input_.flow
	satellite = input_.satellite
	type = input_.type
	
	#print(input_.keys())
	if input_.has("subtype"):
		subtype = input_.subtype
	
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "aspect"
	input.border.subtype = type + " tide"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = satellite.get_mass_value()
	
	match subtype:
		"secret":
			input.content.subtype = 3
		"element":
			input.content.subtype = floor(input.content.subtype * 0.5)
	
	basic.set_attributes(input)
	
	impulse += input.content.subtype


func set_as_tide_breaker() -> void:
#	var input = {}
#	input.proprietor = self
#	input.border = {}
#	input.border.type = "aspect"
#	input.border.subtype = "tidebreaker"
#	input.content = {}
#	input.content.type = "number"
#	input.content.subtype = satellite.get_impulse_value()
#	basic.set_attributes(input)
	
	var input = {}
	input.type = "aspect"
	input.subtype = "tidebreaker"
	basic.border.set_attributes(input)
