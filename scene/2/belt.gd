extends MarginContainer


@onready var kind = $HBox/Kind
@onready var couple = $HBox/Couple

var satellite = null


func set_attributes(input_: Dictionary) -> void:
	satellite = input_.satellite
	
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
	kind.set_attributes(input_.kind)
	
	if !input_.condition.has("type"):
		input_.condition.type = "weight"
		input_.condition.subtype = "any"
	
	input_.condition.proprietor = self
	couple.set_attributes(input_.condition)
		
		#if input_.condition.value < 0:
		#	couple.stack.visible = false


func get_self_bonus_impulse() -> int:
	var value = couple.stack.get_number()
	
	match couple.title.type:
		"phase":
			var phases = satellite.moon.get_satellites_phases()
			value = phases[couple.title.subtype] * couple.stack.get_number_f()
		"moon":
			var moons = satellite.moon.get_satellites_moons()
			value = moons[couple.title.subtype]# * couple.stack.get_number_f()
	
	return ceil(value)


func get_other_bonus_impulse_for_satellite(satellite_: MarginContainer) -> int:
	var value = 0
	
	#match couple.title.type:
		#if check_weight(satellite_):
	var flag = call("check_"+couple.title.type, satellite_)
	
	if flag:
		value += couple.stack.get_number()
	
	return value


func check_weight(satellite_: MarginContainer) -> bool:
	var flag = false
	
	match couple.title.subtype:
		"any":
			flag = true
		"equal":
			flag = satellite_.get_mass_value() == satellite.get_mass_value()
		"heavier":
			flag = satellite_.get_mass_value() > satellite.get_mass_value()
		"lighter":
			flag = satellite_.get_mass_value() < satellite.get_mass_value()
	
	return flag


func check_enchantment(satellite_: MarginContainer) -> bool:
	var flag = false
	
	match couple.title.subtype:
		"any":
			flag = true
		"equal":
			flag = satellite_.enchantment == satellite.enchantment
	
	return flag


func check_element(satellite_: MarginContainer) -> bool:
	var flag = false
	
	match couple.title.subtype:
		"any":
			flag = true
		"equal":
			flag = satellite_.element == satellite.element
	
	return flag
