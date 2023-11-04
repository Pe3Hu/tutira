extends MarginContainer


@onready var health = $VBox/HBox/Health
@onready var satellites = $VBox/Satellites
@onready var flow = $VBox/Flow
@onready var turnoverModifiers = $VBox/HBox/Gravities/Turnovers/Modifiers
@onready var turnoverGravity = $VBox/HBox/Gravities/Turnovers/Gravity
@onready var highModifiers = $VBox/HBox/Gravities/Highs/Modifiers
@onready var highGravity = $VBox/HBox/Gravities/Highs/Gravity


var ocean = null
var lagoon = null


func set_attributes(input_: Dictionary) -> void:
	ocean = input_.ocean
	
	set_nodes_attributes()
	init_starter_gravities()
	init_starter_satellites()
	#init_starter_belts()


func set_nodes_attributes() -> void:
	var input = {}
	input.moon = self
	flow.set_attributes(input)
	input.type = "health"
	input.max = 100
	health.set_attributes(input)


func init_starter_gravities() -> void:
	var input = {}
	input.moon = self
	input.type = "gravity"
	input.subtype = "turnover"
	input.turns = -1
	input.value = 0
	turnoverGravity.set_attributes(input)
	
	input.subtype = "high"
	highGravity.set_attributes(input)
	add_starter_gravity_modifiers()


func add_starter_gravity_modifiers() -> void:
	var input = {}
	input.moon = self
	input.type = "gravity"
	input.subtype = "turnover"
	input.turns = -1
	input.value = 1
	add_modifier(input)
	
	input.value = 1
	input.subtype = "high"
	add_modifier(input)


func add_modifier(input_: Dictionary) -> void:
	var modifiers = get(input_.subtype+"Modifiers")
	var modifier = Global.scene.gravity.instantiate()
	modifiers.add_child(modifier)
	modifier.set_attributes(input_)
	
	var gravity = get(input_.subtype+"Gravity")
	gravity.couple.stack.change_number(modifier.value)


func init_starter_satellites() -> void:
	for title in Global.dict.satellite.title:
		if Global.dict.satellite.title[title].faction == "z":
			var input = {}
			input.moon = self
			input.title = title
		
			var satellite = Global.scene.satellite.instantiate()
			satellites.add_child(satellite)
			satellite.set_attributes(input)


func init_starter_belts() -> void:
	var input = {}
	input.kind = {}
#	input.kind.type = "enchantment"
#	input.kind.subtype = Global.arr.enchantment.pick_random()
#	input.condition = {}
#	input.condition.value = 3
#	input.condition.penalty = 1
	
	input.kind.type = "element"
	input.kind.subtype = Global.arr.element.pick_random()
	input.condition = {}
	input.condition.value = 0.5
	input.condition.penalty = 1
	
	var satellites_ = get_satellites_based_on_mass(4)
	var satellite = satellites_.front()
	#satellite.add_belt(input)
	
	input.kind.type = "sin"
	input.kind.subtype = "envy" #envy pride greed
	input.condition = {}
	input.condition.type = "weight"
	input.condition.subtype = "equal"
#	input.condition.type = "weight"
#	input.condition.subtype = "any"
	input.condition.value = 1
	input.condition.penalty = 0
	

	satellites_ = get_satellites_based_on_mass(1)
	satellite = satellites_.front()
	satellite.add_belt(input)


func get_satellites_based_on_mass(mass_: int) -> Array:
	var result = []
	
	for satellite in satellites.get_children():
		if satellite.aspects.get_mass_value() == mass_:
			result.append(satellite)
	
	return result


func get_satellites_phases() -> Dictionary:
	var milestones = {}
	milestones.passed = 0
	milestones.upcoming = 0
	
	for satellite in satellites.get_children():
		milestones.passed += satellite.aspects.get_passed_value()
		milestones.upcoming += satellite.aspects.get_upcoming_value()
	
	return milestones


func get_satellites_moons() -> Dictionary:
	var moons = {}
	moons.full = 0
	moons.half = 0
	moons.new = 0
	
	for satellite in satellites.get_children():
		var milestones = {}
		milestones.passed = satellite.aspects.get_passed_value()
		milestones.upcoming = satellite.aspects.get_upcoming_value()
		var moon = null
		
		if milestones.passed == 0:
			moon = "new"
		
		if milestones.upcoming == 0:
			moon = "full"
		
		if moon == null:
			moon = "half"
		
		moons[moon] += 1
	
	return moons


func knockout() -> void:
	lagoon.winner = flow.opponent.moon
	lagoon.end = true
	#lagoon.close()
	#print("knockouted ", self)


func reset() -> void:
	lagoon = null
	flow.satellites = []
	flow.refill_satellites()
	health.reset()
	remove_all_gravity_modifiers()
	
	for satellite in satellites.get_children():
		satellite.aspects.remove_symbiote()
		satellite.aspects.reset()


func remove_all_gravity_modifiers() -> void:
	var subtypes = ["high", "turnover"]
	
	for subtype in subtypes:
		var modifiers = get(subtype+"Modifiers")
		var gravity = get(subtype+"Gravity")
		
		while modifiers.get_child_count() > 0:
			var modifier = modifiers.get_child(0)
			modifiers.remove_child(modifier)
			gravity.couple.stack.change_number(-modifier.value)
	
	add_starter_gravity_modifiers()


func remove_all_belts() -> void:
	for satellite in satellites.get_children():
		satellite.remove_all_belts()
