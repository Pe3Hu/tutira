extends MarginContainer


@onready var belts = $Belts 

var ocean = null


func set_attributes(input_: Dictionary) -> void:
	ocean = input_.ocean
	
	create_belts()


func create_belts() -> void:
	create_belts()



func add_belt() -> void:
	var input = {}
	input.kind = {}
	input.kind = {}
	input.kind.type = "element"
	input.kind.subtype = Global.arr.element.pick_random()
	input.condition = {}
	input.condition.value = 0.5
	input.condition.penalty = 1


func belts_fitting() -> void:
	var input = {}
	input.title = "youthfulness"
	input.sin = "anger"
