extends MarginContainer


@onready var health = $VBox/Health
@onready var satellites = $VBox/Satellites
@onready var flow = $VBox/Flow

var ocean = null
var lagoon = null
var gravity = {}


func set_attributes(input_: Dictionary) -> void:
	ocean = input_.ocean
	gravity.high = 1
	gravity.turnover = 2
	
	init_starter_satellites()
	
	var input = {}
	input.moon = self
	
	flow.set_attributes(input)
	input.type = "health"
	input.max = 100
	health.set_attributes(input)


func init_starter_satellites() -> void:
	for title in Global.dict.satellite.title:
		if Global.dict.satellite.title[title].faction == "z":
			var input = {}
			input.ocean = self
			input.title = title
		
			var satellite = Global.scene.satellite.instantiate()
			satellites.add_child(satellite)
			satellite.set_attributes(input)


func knockout() -> void:
	print(self)
