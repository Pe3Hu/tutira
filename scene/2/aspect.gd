extends MarginContainer


@onready var border = $Border
@onready var content = $Content

var proprietor = null


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	var input = {}
	input.type = "aspect"
	input.subtype = input_.border.subtype
	border.set_attributes(input)
	border.custom_minimum_size = Vector2(Global.vec.size.aspect)
	
	set_content(input_)
	custom_minimum_size = Vector2(Global.vec.size.aspect)


func hide_icons() -> void:
	border.visible = false
	content.visible = false


func show_icons() -> void:
	border.visible = true
	content.visible = true


func set_content(input_: Dictionary) -> void:
	match input_.content.type:
		"number":
			content.set_attributes(input_.content)
			content.custom_minimum_size = Vector2(Global.vec.size.aspect)


func get_content_value() -> int:
	return content.get_number()


func change_content_value(value_: int) -> void:
	content.change_number(value_)


func set_content_value(value_: int) -> void:
	content.set_number(value_)
