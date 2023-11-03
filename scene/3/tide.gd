extends MarginContainer


@onready var basic = $Impules/Basic
@onready var bonus = $Impules/Bonus

var flow = null
var satellite = null
var type = null
var subtype = null
var tide = null
var impulse = 0


func set_attributes(input_: Dictionary) -> void:
	flow = input_.flow
	satellite = input_.satellite
	type = input_.type
	
	if input_.has("subtype"):
		subtype = input_.subtype
	
	if input_.has("tide"):
		tide = input_.tide
	
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "aspect"
	input.border.subtype = type + " tide"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = satellite.aspects.get_mass_value()
	custom_minimum_size = Vector2(Global.vec.size.tide)
	
	match subtype:
		"secret":
			input.content.subtype = 3
		"legacy":
			input.content.subtype = ceil(tide.impulse * 0.5)
	
	basic.set_attributes(input)
	impulse += input.content.subtype
	
	if subtype == null:
		apply_self_belts()
		apply_other_belts()


func set_as_tidebreaker() -> void:
	var input = {}
	input.type = "tide"
	input.subtype = "tidebreaker"
	basic.border.set_attributes(input)
	impulse = satellite.aspects.get_mass_value()#basic.get_content_value()
	#custom_minimum_size = Vector2(Global.vec.size.tidebreaker)
	#print(impulse)
	if subtype == null:
		apply_self_belts()
		apply_other_belts()


func apply_self_belts() -> void:
	if Global.dict.sin.self.has(satellite.sin):
		for belt in satellite.belts.get_children():
			if Global.dict.sin.self.has(belt.kind.subtype):
				if Global.dict.sin.self[belt.kind.subtype] == basic.border.subtype:
					var value = belt.get_self_bonus_impulse()
					
					if basic.border.subtype == "tidebreaker":
						value *= 2
					
					impulse += value
					basic.set_content_value(impulse)


func apply_other_belts() -> void:
	var value = 0
	
	for satellite_ in satellite.moon.satellites.get_children():
		if Global.dict.sin.other.has(satellite_.sin):
			for belt in satellite_.belts.get_children(): 
				if Global.dict.sin.other.has(belt.kind.subtype):
					if Global.dict.sin.other[belt.kind.subtype] == basic.border.subtype or Global.dict.sin.other[belt.kind.subtype] == "all":
						value += belt.get_other_bonus_impulse_for_satellite(satellite)
	
	if basic.border.subtype == "tidebreaker":
		pass
	
	impulse += value
	basic.set_content_value(impulse)
