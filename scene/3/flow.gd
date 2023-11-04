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
var tidebreaker = null
var opponent = null


func set_attributes(input_: Dictionary) -> void:
	moon = input_.moon
	
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "tide"
	input.border.subtype = "high wave"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = 0
	impulse.set_attributes(input)
	#impulse.custom_minimum_size = Vector2(Global.vec.size.tidebreaker)


func refill_satellites() -> void:
	for satellite in moon.satellites.get_children():
		satellite.aspects.turnover()
		
		for _i in satellite.aspects.get_upcoming_value():
			satellites.append(satellite)
	
	satellites.shuffle()


func douse_wave() -> void:
	while impulse.get_content_value() < opponent.impulse.get_content_value() and !moon.lagoon.end:
		ride_wave("low")
		var splash = opponent.impulse.get_content_value() - impulse.get_content_value()
		moon.health.update_value("current", -splash)


func set_tidebreaker() -> void:
	if lows.get_child_count() > 0:
		tidebreaker = lows.get_child(lows.get_child_count()-1)
		lows.remove_child(tidebreaker)
		highs.add_child(tidebreaker)
		tidebreaker.set_as_tidebreaker()
		impulse.change_content_value(tidebreaker.impulse)
		
		var input = {}
		input.flow = self
		input.satellite = tidebreaker.satellite
		input.type = "high"
		input.tide = tidebreaker
		add_secret(input)
		add_legacy(input)


func clean_tidebreaker() -> void:
	if tidebreaker != null:
		if tidebreaker.get_parent() != null:
			var parent = tidebreaker.get_parent()
			parent.remove_child(tidebreaker)
		
		tidebreaker.queue_free()
		tidebreaker = null


func ride_wave(type_: String) -> void:
	if satellites.is_empty():
		refill_satellites()
		add_turnover_modifiers()
		#print("reseted")
	
	var input = {}
	input.flow = self
	input.satellite = satellites.pop_front()
	input.type = type_
	input.satellite.aspects.next_milestone()
	
	var tides = get(type_+"s")
	var tide = Global.scene.tide.instantiate()
	tides.add_child(tide)
	tide.set_attributes(input)
	impulse.change_content_value(tide.impulse)
	
	input.tide = tide
	add_secret(input)
	add_legacy(input)


func add_turnover_modifiers() -> void:
	var input = {}
	input.moon = opponent.moon
	input.type = "gravity"
	input.subtype = "high"
	input.turns = 1
	input.value = moon.turnoverGravity.get_gravity_value()
	opponent.moon.add_modifier(input)
	
	input.moon = moon
	input.type = "gravity"
	input.subtype = "turnover"
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
		if input_.type == "high" or  Global.dict.dominant.element[opponent.element.subtype] == input_.satellite.element:
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
	input.type = "tide"
	input.subtype = null
	
	match striker_:
		true:
			input.subtype = "high wave"
		false:
			input.subtype = "low wave"
	
	impulse.border.set_attributes(input)
	impulse.set_content_value(0)
