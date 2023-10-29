extends MarginContainer


@onready var title = $VBox/Title
@onready var aspects = $VBox/Aspects
@onready var impulse = $VBox/Aspects/Impulse
@onready var maxCharge = $VBox/Aspects/MaxCharge
@onready var currentCharge = $VBox/Aspects/CurrentCharge

var ocean = null


func set_attributes(input_: Dictionary) -> void:
	ocean = input_.ocean
	title.text = input_.title
	
	set_aspects()


func set_aspects() -> void:
	var description = Global.dict.satellite.title[title.text]
	var input = {}
	input.proprietor = self
	input.border = {}
	input.border.type = "aspect"
	input.border.subtype = "impulse"
	input.content = {}
	input.content.type = "number"
	input.content.subtype = description.impulse
	impulse.set_attributes(input)
	input.border.subtype = "charge"
	input.content.subtype = description.charge
	maxCharge.set_attributes(input)
	maxCharge.hide_icons()
	currentCharge.set_attributes(input)


func get_impulse_value() -> int:
	return impulse.get_content_value()


func get_max_charge_value() -> int:
	return maxCharge.get_content_value()


func get_current_charge_value() -> int:
	return currentCharge.get_content_value()


