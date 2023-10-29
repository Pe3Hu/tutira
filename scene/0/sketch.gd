extends MarginContainer


@onready var ocean = $HBox/Ocean


func _ready() -> void:
	var input = {}
	input.sketch = self
	ocean.set_attributes(input)
