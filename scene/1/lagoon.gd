extends MarginContainer


@onready var moons = $VBox/Moons

var ocean = null
var opponents = {}
var striker = null


func set_attributes(input_: Dictionary) -> void:
	ocean = input_.ocean
	
	for moon in input_.moons:
		add_moon(moon)
	
	opponents[moons.get_child(0)] = moons.get_child(1)
	opponents[moons.get_child(1)] = moons.get_child(0)
	
	moons.get_child(0).flow.opponent = moons.get_child(1).flow
	moons.get_child(1).flow.opponent = moons.get_child(0).flow
	
	dip()



func add_moon(moon_: MarginContainer) -> void:
	ocean.moons.remove_child(moon_)
	moons.add_child(moon_)
	moon_.lagoon = self
	moon_.flow.refill_satellites()


func dip() -> void:
	call_in_tide()


func call_in_tide() -> void:
	if striker == null:
		striker = moons.get_child(0)
	else:
		striker.flow = null
	
	
	for _i in striker.gravity.high:
		striker.flow.ride_wave("high")
	

