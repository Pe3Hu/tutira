extends MarginContainer


@onready var moons = $HBox/Moons
@onready var lagoons = $HBox/Lagoons


var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_moons()
	init_lagoon()


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
