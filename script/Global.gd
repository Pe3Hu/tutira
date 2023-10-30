extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.phase = ["init_high_waves", "init_low_waves", "reset_waves"]


func init_num() -> void:
	num.index = {}


func init_dict() -> void:
	init_neighbor()
	init_satellite()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_satellite() -> void:
	dict.satellite = {}
	dict.satellite.title = {}
	
	var path = "res://asset/json/tutira_satellite.json"
	var array = load_data(path)
	
	for satellite in array:
		var data = {}
		
		for key in satellite:
			if key != "title":
				data[key] = satellite[key]
		
		dict.satellite.title[str(satellite.title)] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.sketch = load("res://scene/0/sketch.tscn")
	
	scene.moon = load("res://scene/1/moon.tscn")
	scene.lagoon = load("res://scene/1/lagoon.tscn")
	
	scene.satellite = load("res://scene/2/satellite.tscn")
	
	scene.gravity = load("res://scene/3/gravity.tscn")
	scene.tide = load("res://scene/3/tide.tscn")
	pass


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.aspect = Vector2(40, 40)
	vec.size.bar = Vector2(120, 12)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(0, 1, 0.9)
	color.indicator.health.background = Color.from_hsv(0, 0.25, 0.9)
	color.indicator.endurance = {}
	color.indicator.endurance.fill = Color.from_hsv(0.33, 1, 0.9)
	color.indicator.endurance.background = Color.from_hsv(0.33, 0.25, 0.9)
	color.indicator.barrier = {}
	color.indicator.barrier.fill = Color.from_hsv(0.5, 1, 0.9)
	color.indicator.barrier.background = Color.from_hsv(0.5, 0.25, 0.9)



func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null