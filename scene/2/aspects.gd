extends MarginContainer


@onready var mass = $HBox/Mass
@onready var passed = $HBox/Passed
@onready var upcoming = $HBox/Upcoming

var satellite = null
var dimensions = {}
var symbiote = null


func set_attributes(input_: Dictionary) -> void:
	satellite = input_.satellite
	
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
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
	
	dimensions.mass = description.mass
	dimensions.milestone = description.milestone
	dimensions.belt = 0
	dimensions.total = dimensions.mass + dimensions.milestone


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


func apply_symbiote(symbiote_: Dictionary) -> void:
	if symbiote == null:
		symbiote = symbiote_
		
		for dimension in symbiote:
			dimensions[dimension] += symbiote[dimension]
			dimensions.total += symbiote[dimension]
		
		reset()
		print([symbiote_, mass.stack.get_number(), upcoming.stack.get_number()])
	else:
		print("error: simbiote != null")


func remove_symbiote() -> void:
	if symbiote != null:
		for dimension in symbiote:
			dimensions[dimension] -= symbiote[dimension]
			dimensions.total -= symbiote[dimension]
		
		reset()
		symbiote = null


func reset() -> void:
	mass.stack.set_number(dimensions.mass)
	upcoming.stack.set_number(dimensions.milestone)
