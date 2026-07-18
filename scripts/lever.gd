extends StaticBody2D
class_name Lever
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_left: bool = true

func _ready() -> void:
	if is_left:
		left()
	else:
		right()

func left() -> void:
	is_left = true
	animation_player.play("left")

func right() -> void:
	is_left = false
	animation_player.play("right")
