extends MarginContainer


@onready var mass = $HBox/Mass
@onready var passed = $HBox/Passed
@onready var upcoming = $HBox/Upcoming

var satellite = null
var aspects = {}


func set_attributes(input_: Dictionary) -> void:
	satellite = input_.satellite

	var description = Global.dict.satellite.title[satellite.title.text]
	var input = {}
	input.proprietor = self
	input.type = "aspect"
	input.subtype = "mass"
	input.value = description.mass
	mass.set_attributes(input)
	
	input.subtype = "passed"
	input.value = 0
	passed.set_attributes(input)
	
	input.subtype = "upcoming"
	input.value = description.milestone
	upcoming.set_attributes(input)
	
	aspects.mass = description.mass
	aspects.milestone = description.milestone
	aspects.belt = 0
	aspects.total = aspects.mass + aspects.milestone


func get_mass_value() -> int:
	return mass.stack.get_number()


func get_passed_value() -> int:
	return passed.stack.get_number()


func get_upcoming_value() -> int:
	return upcoming.stack.get_number()


func next_milestone() -> void:
	upcoming.stack.change_number(-1)
	passed.stack.change_number(1)


func turnover() -> void:
	if get_passed_value() != 0:
		upcoming.stack.set_number(get_passed_value())
		passed.stack.set_number(0)
