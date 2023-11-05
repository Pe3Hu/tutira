extends MarginContainer


@onready var moons = $HBox/Moons
@onready var lagoons = $HBox/Lagoons
@onready var tombolo = $HBox/Tombolo

var sketch = null
var statistics = []


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_moons()
	#simulate_belt_balance()
	#var path = "res://asset/json/tutira_statistics.json.json"
	#var file_dict = Global.load_data(path)
	#print(file_dict)
	#init_lagoon()
	
#	for _i in 10:
#		init_lagoon()
#		var lagoon = lagoons.get_child(0)
#		lagoon.skip_phases()
#		lagoon.close()


func init_moons() -> void:
	for _i in 2:
		var input = {}
		input.ocean = self
	
		var moon = Global.scene.moon.instantiate()
		moons.add_child(moon)
		moon.set_attributes(input)


func init_lagoon() -> void:
	var input = {}
	input.ocean = self
	input.moons = [moons.get_child(0), moons.get_child(1)]
	var lagoon = Global.scene.lagoon.instantiate()
	lagoons.add_child(lagoon)
	lagoon.set_attributes(input)


func simulate_belt_balance() -> void:
	#var title = "youthfulness"
	var k = 10
	
	for _i in 5:#range(1, 7, 1):
		for title in Global.dict.belt.title:
			var description = Global.dict.belt.title[title]
			
			for sin in Global.dict.sin[description.token]:
				var input = {}
				input.mass = _i + 1
				input.title = title
				input.sin = sin
				print(input.mass)
				
				var healths = [0, 0]
			
				for _k in k:
					add_simulated_belt_to_moon(input)
					init_lagoon()
					var lagoon = lagoons.get_child(0)
					lagoon.skip_phases()
					var result = lagoon.get_result()
					#print([sin, result])
					
					for _j in result.size():
						healths[_j] += result[_j]
					
					lagoon.close()
				
				var data = {}
				data.mass = input.mass
				data.title = input.title
				data.sin = input.sin
				
				for _j in healths.size():
					var key = "health "+ str(_j)
					data[key] = float(healths[_j] / k)
					#print(data)
				statistics.append(data)
					#print(statistics)
				
			#return
	
	Global.save_statistics(statistics)
	#print(statistics)


func add_simulated_belt_to_moon(input_: Dictionary) -> void:
	var description = Global.dict.belt.title[input_.title]
	var moon = moons.get_child(0)
	var input = {}
	input.kind = {}
	input.kind.type = "sin"
	input.kind.subtype = input_.sin
	input.condition = {}
	
	if description.has("type"):
		input.condition.type = description.type
		input.condition.subtype =  description.subtype
	
	input.condition.value = description.value
	input.condition.penalty = description.penalty
	
	var satellites = moon.get_satellites_based_on_mass(1)
	var satellite = satellites.front()
	satellite.remove_all_belts()
	satellite.aspects.remove_symbiote()
	satellite.add_belt(input)
	
	var symbiote = create_symbiote_passed_on_satellite(satellite, description.penalty)
	satellite.aspects.apply_symbiote(symbiote)
	


func create_symbiote_passed_on_satellite(satellite_: MarginContainer, penalty_: int) -> Dictionary:
	var symbiote = {}
	var options = []
	
	for dimension in Global.arr.dimension:
		symbiote[dimension] = 0
		
		for _i in satellite_.aspects.dimensions[dimension] - 1:
			options.append(dimension)
	
	while penalty_ > 0:
		var dimension = options.pick_random()
		symbiote[dimension] -= 1
		options.erase(dimension)
		penalty_ -= 1
	
	return symbiote
