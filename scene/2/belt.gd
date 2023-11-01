extends MarginContainer


@onready var kind = $HBox/Kind
@onready var couple = $HBox/Couple

var satellite = null


func set_attributes(input_: Dictionary) -> void:
	satellite = input_.satellite
	
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
	kind.set_attributes(input_.kind)
	
	if input_.condition.has("type"):
		input_.condition.proprietor = self
		couple.set_attributes(input_.condition)
		
		if input_.condition.value < 0:
			couple.stack.visible = false
