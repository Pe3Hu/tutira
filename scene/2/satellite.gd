extends MarginContainer


@onready var title = $VBox/Title
@onready var aspects = $VBox/Aspects
@onready var belts = $VBox/Belts
@onready var mass = $VBox/Aspects/Mass
@onready var maxMilestone = $VBox/Aspects/MaxMilestone
@onready var currentMilestone = $VBox/Aspects/CurrentMilestone

var moon = null
var enchantment = null
var element = null
var sin = null


func set_attributes(input_: Dictionary) -> void:
	moon = input_.moon
	title.text = input_.title
	
	set_aspects()


func set_aspects() -> void:
	var description = Global.dict.satellite.title[title.text]
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "aspect"
	input.border.subtype = "mass"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = description.mass
	mass.set_attributes(input)
	input.border.subtype = "milestone"
	input.content.subtype = description.milestone
	maxMilestone.set_attributes(input)
	maxMilestone.hide_icons()
	currentMilestone.set_attributes(input)


func get_mass_value() -> int:
	return mass.get_content_value()


func get_max_milestone_value() -> int:
	return maxMilestone.get_content_value()


func get_current_milestone_value() -> int:
	return currentMilestone.get_content_value()


func add_belt(input_: Dictionary) -> void:
	if get(input_.kind.type) == null:
		set(input_.kind.type, input_.kind.subtype)
		input_.satellite = self
		#kind = input_.kind.subtype
		
		var belt = Global.scene.belt.instantiate()
		belts.add_child(belt)
		belt.set_attributes(input_)
	else:
		print("erro: kind != null")
