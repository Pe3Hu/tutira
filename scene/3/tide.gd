extends MarginContainer


@onready var basic = $Impules/Basic
@onready var bonus = $Impules/Bonus

var flow = null
var satellite = null
var type = null
var subtype = null
var tidebreaker = false
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
		"legacy":
			input.content.subtype = ceil(input.content.subtype * 0.5)
	
	basic.set_attributes(input)
	impulse += input.content.subtype
	apply_self_belts()
	apply_other_belts()


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
	
	tidebreaker = true
	var input = {}
	input.type = "aspect"
	input.subtype = "tidebreaker"
	basic.border.set_attributes(input)


func apply_self_belts() -> void:
	if Global.dict.sin.self.has(satellite.sin):
		for belt in satellite.belts.get_children():
			if Global.dict.sin.self.has(belt.kind.subtype):
				if Global.dict.sin.self[belt.kind.subtype] == basic.border.subtype:
				#if Global.dict.sin.self[belt.kind.subtype] == type  or (Global.dict.sin.other[belt.kind.subtype] == "tidebreaker" and tidebreaker):
					var value = belt.get_self_bonus_impulse()
					
					if tidebreaker:
						value *= 2
					
					impulse += value
					basic.set_content_value(impulse)


func apply_other_belts() -> void:
	var value = 0
	
	if tidebreaker:
		pass
	
	for satellite_ in satellite.moon.satellites.get_children():
		if Global.dict.sin.other.has(satellite_.sin):
			for belt in satellite_.belts.get_children(): 
				if Global.dict.sin.other.has(belt.kind.subtype):
					if Global.dict.sin.other[belt.kind.subtype] == basic.border.subtype or Global.dict.sin.other[belt.kind.subtype] == "all":
					#if (Global.dict.sin.other[belt.kind.subtype] == type or (Global.dict.sin.other[belt.kind.subtype] == "tidebreaker" and tidebreaker)) or Global.dict.sin.other[belt.kind.subtype] == "all":
						value += belt.get_other_bonus_impulse_for_satellite(satellite)
	
	impulse += value
	basic.set_content_value(impulse)
