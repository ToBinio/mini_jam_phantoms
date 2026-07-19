extends HSlider

func _ready() -> void:
	value = 0.5
	AudioServer.set_bus_volume_linear(0, 0.5)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
