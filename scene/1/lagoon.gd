extends MarginContainer


@onready var moons = $VBox/Moons

var ocean = null
var striker = null
var winner = null
var opponents = {}
var phases = []
var turn = 0
var end = false


func set_attributes(input_: Dictionary) -> void:
	ocean = input_.ocean
	
	for moon in input_.moons:
		add_moon(moon)
	
	opponents[moons.get_child(0)] = moons.get_child(1)
	opponents[moons.get_child(1)] = moons.get_child(0)
	
	moons.get_child(0).flow.opponent = moons.get_child(1).flow
	moons.get_child(1).flow.opponent = moons.get_child(0).flow
	
	switch_striker()
	
	for _i in 30:
		follow_phase()


func add_moon(moon_: MarginContainer) -> void:
	ocean.moons.remove_child(moon_)
	moons.add_child(moon_)
	moon_.lagoon = self
	moon_.flow.refill_satellites()


func reset_phases() -> void:
	turn += 1
	phases.append_array(Global.arr.phase)


func follow_phase() -> void:
	if !end:
		if phases.is_empty() and !end:
			reset_phases()
		
		var phase = phases.pop_front()
		call(phase)


func init_high_waves() -> void:
	striker.flow.clean_tides("high")
	striker.flow.set_tide_breaker()
	
	for _i in striker.highGravity.get_content_value():
		striker.flow.ride_wave("high")


func init_low_waves() -> void:
	var moon = opponents[striker]
	moon.flow.clean_tides("low")
	moon.flow.douse_wave()


func reset_waves() -> void:
	#var moon = opponents[striker]
	#striker.flow.clean_tides("high")
	#striker = opponents[striker]
	switch_striker()


func switch_striker() -> void:
	if striker == null:
		striker = moons.get_child(0)
	else:
		striker = opponents[striker]
	
	var moon = opponents[striker]
	striker.flow.set_impulse_as_striker(true)
	striker.flow.lows.visible = false
	striker.flow.highs.visible = true
	moon.flow.set_impulse_as_striker(false)
	moon.flow.lows.visible = true
	moon.flow.highs.visible = false
	moon.flow.clean_tide_breaker()

