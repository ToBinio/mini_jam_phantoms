extends StaticBody2D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_open: bool = true

func _ready() -> void:
	if is_open:
		open()
	else:
		close()

func open() -> void:
	is_open = true
	animation_player.play("open")

func close() -> void:
	is_open = false
	animation_player.play("close")
