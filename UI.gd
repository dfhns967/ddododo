extends Control

var mouse_sensitivity

var values = {
	10: 0.1,
	11: 0.2,
	12: 0.3,
	13: 0.4,
	14: 0.5,
	15: 0.6,
	16: 0.7,
	17: 0.8,
	18: 0.9,
	19: 1
}



func _ready():
	pass

func _on_HSlider_value_changed(value):
	mouse_sensitivity = value
	print()
