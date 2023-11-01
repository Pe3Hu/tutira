extends MarginContainer


@onready var highs = $HBox/Tides/Highs
@onready var lows = $HBox/Tides/Lows
@onready var enchantment = $HBox/Tides/Enchantment
@onready var secrets = $HBox/Tides/Secrets
@onready var element = $HBox/Tides/Element
@onready var legacies = $HBox/Tides/Legacies
@onready var impulse = $HBox/Impulse

var moon = null
var satellites = []
var tide_breaker = null
var opponent = null


func set_attributes(input_: Dictionary) -> void:
	moon = input_.moon
	
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "aspect"
	input.border.subtype = "high wave"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = 0
	impulse.set_attributes(input)


func refill_satellites() -> void:
	for satellite in moon.satellites.get_children():
		for _i in satellite.get_max_milestone_value():
			satellites.append(satellite)
		
		satellite.currentMilestone.set_content_value(satellite.maxMilestone.get_content_value())
	
	satellites.shuffle()


func douse_wave() -> void:
	while impulse.get_content_value() < opponent.impulse.get_content_value() and !moon.lagoon.end:
		ride_wave("low")
		var splash = opponent.impulse.get_content_value() - impulse.get_content_value()
		moon.health.update_value("current", -splash)


func set_tide_breaker() -> void:
	if lows.get_child_count() > 0:
		#var a = lows.get_child_count()-1
		#var b = lows.get_children()
		tide_breaker = lows.get_child(lows.get_child_count()-1)
		lows.remove_child(tide_breaker)
		highs.add_child(tide_breaker)
		tide_breaker.set_as_tide_breaker()
		impulse.change_content_value(tide_breaker.impulse)
		
		var input = {}
		input.flow = self
		input.satellite = tide_breaker.satellite
		input.type = "high"
		add_secret(input)
		add_legacy(input)


func clean_tide_breaker() -> void:
	if tide_breaker != null:
		highs.remove_child(tide_breaker)
		tide_breaker.queue_free()
		tide_breaker = null


func ride_wave(type_: String) -> void:
	if satellites.is_empty():
		refill_satellites()
		add_turnover_modifiers()
		#print("reseted")
	
	var input = {}
	input.flow = self
	input.satellite = satellites.pop_front()
	input.type = type_
	
	var tides = get(type_+"s")
	var tide = Global.scene.tide.instantiate()
	tides.add_child(tide)
	tide.set_attributes(input)
	
	impulse.change_content_value(tide.impulse)
	
	add_secret(input)
	add_legacy(input)
	input.satellite.currentMilestone.change_content_value(-1)


func add_turnover_modifiers() -> void:
	var input = {}
	input.moon = opponent.moon
	input.type = "high"
	input.turns = 1
	input.value = moon.turnoverGravity.get_content_value()
	opponent.moon.add_modifier(input)
	
	input.moon = moon
	input.type = "turnover"
	input.turns = -1
	input.value = 1
	moon.add_modifier(input)


func add_secret(input_: Dictionary) -> void:
	if input_.satellite.enchantment != null:
		if input_.type == "high" or Global.dict.dominant.enchantment[opponent.enchantment.subtype] == input_.satellite.enchantment:
			if secrets.get_child_count() == 0:
				secrets.visible = true
			
				var input = {}
				input.type = "enchantment"
				input.subtype = input_.satellite.enchantment
				enchantment.set_attributes(input)
				enchantment.visible = true
				
				input_.subtype = "secret"
			
			var tide = Global.scene.tide.instantiate()
			secrets.add_child(tide)
			tide.set_attributes(input_)
			impulse.change_content_value(tide.impulse)


func add_legacy(input_: Dictionary) -> void:
	if input_.satellite.element != null:
		if input_.type == "high" or  Global.dict.dominant.element[opponent.element] == input_.satellite.element:
			if legacies.get_child_count() == 0:
				legacies.visible = true
				
				var input = {}
				input.type = "element"
				input.subtype = input_.satellite.element
				element.set_attributes(input)
				element.visible = true
			
			input_.subtype = "legacy"
			
			var tide = Global.scene.tide.instantiate()
			legacies.add_child(tide)
			tide.set_attributes(input_)
			impulse.change_content_value(tide.impulse)


func clean_tides(type_: String) -> void:
	var tides = get(type_+"s")
	
	match type_:
		"legacie":
			tides.visible = false
			element.visible = false
		"secret":
			tides.visible = false
			enchantment.visible = false
	
	while tides.get_child_count() > 0:
		var tide = tides.get_child(0)
		tides.remove_child(tide)
		tide.queue_free()
	
	impulse.set_content_value(0)


func set_impulse_as_striker(striker_: bool) -> void:
	var input = {}
	input.type = "aspect"
	input.subtype = null
	
	match striker_:
		true:
			input.subtype = "high wave"
		false:
			input.subtype = "low wave"
	
	impulse.border.set_attributes(input)
	impulse.set_content_value(0)
