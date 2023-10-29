extends MarginContainer


@onready var basic = $Impules/Basic
@onready var bonus = $Impules/Bonus

var flow = null
var satellite = null
var type = null
var impulse = 0


func set_attributes(input_: Dictionary) -> void:
	flow = input_.flow
	satellite = input_.satellite
	type = input_.type
	
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "aspect"
	input.border.subtype = "impulse"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = satellite.get_impulse_value()
	basic.set_attributes(input)
	
	impulse += satellite.get_impulse_value()
