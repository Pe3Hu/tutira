extends MarginContainer


@onready var highs = $HBox/Tides/Highs
@onready var lows = $HBox/Tides/Lows
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
		for _i in satellite.get_max_charge_value():
			satellites.append(satellite)
		
		satellite.currentCharge.set_content_value(satellite.maxCharge.get_content_value())
	
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
	input.satellite.currentCharge.change_content_value(-1)
	
	var tides = get(type_+"s")
	var tide = Global.scene.tide.instantiate()
	tides.add_child(tide)
	tide.set_attributes(input)
	
	impulse.change_content_value(tide.impulse)


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


func clean_tides(type_: String) -> void:
	var tides = get(type_+"s")
	
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
