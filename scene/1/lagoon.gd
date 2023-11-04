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
	#skip_phases()


func add_moon(moon_: MarginContainer) -> void:
	ocean.moons.remove_child(moon_)
	moons.add_child(moon_)
	moon_.reset()
	moon_.lagoon = self


func reset_phases() -> void:
	turn += 1
	phases.append_array(Global.arr.phase)


func follow_phase() -> void:
	if !end:
		if phases.is_empty() and !end:
			reset_phases()
		
		var phase = phases.pop_front()
		print(phase)
		call(phase)
	else:
		print("closed")
	#	call("close")


func init_high_waves() -> void:
	striker.flow.set_tidebreaker()
	
	for _i in striker.highGravity.get_gravity_value():
		striker.flow.ride_wave("high")


func init_low_waves() -> void:
	var moon = opponents[striker]
	#moon.flow.clean_tides("low")
	moon.flow.douse_wave()


func reset_waves() -> void:
	switch_striker()


func switch_striker() -> void:
	if striker == null:
		striker = moons.get_child(0)
	else:
		striker = opponents[striker]
	
	striker.flow.set_impulse_as_striker(true)
	striker.flow.lows.visible = false
	striker.flow.highs.visible = true
	striker.flow.clean_tides("high")
	striker.flow.clean_tides("secret")
	striker.flow.clean_tides("legacie")
	
	var moon = opponents[striker]
	moon.flow.set_impulse_as_striker(false)
	moon.flow.lows.visible = true
	moon.flow.highs.visible = false
	moon.flow.clean_tides("low")
	moon.flow.clean_tides("secret")
	moon.flow.clean_tides("legacie")
	moon.flow.clean_tidebreaker()


func skip_phases() -> void:
	while !end:
		follow_phase()


func get_result() -> Array:
	var result = []
	
	for moon in moons.get_children():
		var health = moon.health.bar.value
		result.append(health)
	
	#print(result)
	return result


func close() -> void:
	#get_result()
	
	while moons.get_child_count() > 0:
		var moon = moons.get_child(0)
		moons.remove_child(moon)
		ocean.moons.add_child(moon)
	
	ocean.lagoons.remove_child(self)
	queue_free()
