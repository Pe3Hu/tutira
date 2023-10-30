extends MarginContainer


@onready var border = $Border
@onready var content = $Content

var moon = null
var type = null
var turns = null
var value = null


func set_attributes(input_: Dictionary) -> void:
	moon = input_.moon
	type = input_.type
	turns = input_.turns
	value = input_.value
	
	var input = {}
	input.type = "aspect"
	input.subtype = "gravity " + input_.type
	border.set_attributes(input)
	border.custom_minimum_size = Vector2(Global.vec.size.aspect)
	
	input.type = "number"
	input.subtype = input_.value
	content.set_attributes(input)
	content.custom_minimum_size = Vector2(Global.vec.size.aspect)
	custom_minimum_size = Vector2(Global.vec.size.aspect)
