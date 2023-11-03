extends MarginContainer


@onready var couple = $Couple

var moon = null
var subtype = null
var turns = null
var value = null


func set_attributes(input_: Dictionary) -> void:
	moon = input_.moon
	subtype = input_.subtype
	turns = input_.turns
	value = input_.value
	
	input_.proprietor = self
	couple.set_attributes(input_)


func get_gravity_value() -> int:
	return couple.stack.get_number()
