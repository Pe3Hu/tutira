extends MarginContainer


@onready var number = $Number
@onready var tr = $TextureRect

var type = null
var subtype = null


func set_attributes(input_: Dictionary) -> void:
	type  = input_.type
	subtype  = input_.subtype
	
	custom_minimum_size = Vector2(Global.vec.size.letter)
	var path = "res://asset/png/icon/"
	var types = []
	var tokens = ["aspect", "enchantment", "element", "sin", "phase", "moon", "weight", "gravity", "tide"]
	
	if types.has(type):
		custom_minimum_size = Vector2(Global.vec.size.icon)
		path += type + "/" + subtype + ".png"
		tr.texture = load(path)
	
	if tokens.has(type):
		custom_minimum_size = Vector2(Global.vec.size.token)
		path += "token/" + type + "/" + subtype + ".png"
		
		if type == "tide":
			custom_minimum_size = Vector2(Global.vec.size.tide)
		
		tr.texture = load(path)
	
	match type:
		"number":
			custom_minimum_size = Vector2(Global.vec.size.number)
			tr.visible = false
			number.visible = true
			set_number(subtype)
		"blank":
			custom_minimum_size = Vector2(Global.vec.size.number)


func get_number() -> int:
	return int(subtype)


func get_number_f() -> float:
	return float(subtype)


func change_number(value_) -> void:
	subtype += value_
	var value = subtype + 0
	
	match typeof(value_):
		TYPE_INT:
			var suffix = ""
			
			while value >= 1000:
				value /= 1000
				suffix = Global.dict.thousand[suffix]
			
			number.text = str(value) + suffix
		TYPE_FLOAT:
			value = snapped(value, 0.01)
			number.text = str(value)


func set_number(value_) -> void:
	subtype = value_
	var value = subtype + 0
	
	match typeof(value_):
		TYPE_INT:
			var suffix = ""
			
			while value >= 1000:
				value /= 1000
				suffix = Global.dict.thousand[suffix]
			
			number.text = str(value) + suffix
		TYPE_FLOAT:
			value = snapped(value, 0.01)
			number.text = str(value)

