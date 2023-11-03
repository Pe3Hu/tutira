extends MarginContainer


@onready var title = $VBox/Title
@onready var aspects = $VBox/Aspects
@onready var belts = $VBox/Belts

var moon = null
var enchantment = null
var element = null
var sin = null


func set_attributes(input_: Dictionary) -> void:
	moon = input_.moon
	title.text = input_.title
	
	input_.satellite = self
	aspects.set_attributes(input_)


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
