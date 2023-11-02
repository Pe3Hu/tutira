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
	init_starter_belts()


func set_nodes_attributes() -> void:
	var input = {}
	input.moon = self
	flow.set_attributes(input)
	input.type = "health"
	input.max = 100
	health.set_attributes(input)


func init_starter_gravities() -> void:
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "aspect"
	input.border.subtype = "gravity turnover"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = 0
	turnoverGravity.set_attributes(input)
	
	input.border.subtype = "gravity high"
	highGravity.set_attributes(input)
	
	input.moon = self
	input.type = "turnover"
	input.turns = -1
	input.value = 1
	add_modifier(input)
	
	input.type = "high"
	add_modifier(input)


func add_modifier(input_: Dictionary) -> void:
	var modifiers = get(input_.type+"Modifiers")
	var modifier = Global.scene.gravity.instantiate()
	modifiers.add_child(modifier)
	modifier.set_attributes(input_)
	
	var gravity = get(input_.type+"Gravity")
	gravity.change_content_value(modifier.value)


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
	
#	input.kind.type = "element"
#	input.kind.subtype = Global.arr.element.pick_random()
#	input.condition = {}
#	input.condition.value = 0.5
#	input.condition.penalty = 1
	
	input.kind.type = "sin"
	input.kind.subtype = "envy"
	input.condition = {}
	input.condition.type = "weight"
	input.condition.subtype = "any"
	input.condition.value = 1
	input.condition.penalty = 0
	
	var satellites_ = get_satellites_based_on_mass(1)
	var satellite = satellites_.front()
	
	satellite.add_belt(input)


func get_satellites_based_on_mass(mass_: int) -> Array:
	var result = []
	
	for satellite in satellites.get_children():
		if satellite.get_mass_value() == mass_:
			result.append(satellite)
	
	return result


func get_satellites_phases() -> Dictionary:
	var phases = {}
	phases.total = 0
	phases.upcoming = 0
	
	for satellite in satellites.get_children():
		phases.total += satellite.maxMilestone.get_content_value()
		phases.upcoming += satellite.currentMilestone.get_content_value()
	
	phases.passed = phases.total - phases.upcoming
	#print(phases)
	return phases


func get_satellites_moons() -> Dictionary:
	var moons = {}
	moons.full = 0
	moons.half = 0
	moons.new = 0
	
	for satellite in satellites.get_children():
		var milestones = {}
		milestones.current = satellite.currentMilestone.get_content_value()
		milestones.max = satellite.maxMilestone.get_content_value()
		var moon = null
		
		match milestones.current:
			milestones.max:
				moon = "full"
			0:
				moon = "new"
		
		if moon == null:
			moon = "half"
		
		print([satellite.get_index(), moon])
		moons[moon] += 1
	print(moons)
	return moons


func knockout() -> void:
	lagoon.winner = flow.opponent.moon
	lagoon.end = true
	print("knockouted ", self)
