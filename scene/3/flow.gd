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
	input.border.subtype = "impulse"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = 0
	impulse.set_attributes(input)


func refill_satellites() -> void:
	for satellite in moon.satellites.get_children():
		for _i in satellite.get_max_charge_value():
			satellites.append(satellite)
	
	satellites.shuffle()


func set_tide_breaker() -> void:
	while impulse.get_content_value() < opponent.impulse.get_content_value():
		ride_wave("low")


func ride_wave(type_: String) -> void:
	if satellites.is_empty():
		refill_satellites()
		print("reseted")
	
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
