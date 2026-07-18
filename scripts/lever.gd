extends StaticBody2D
class_name Lever
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_left: bool = true

@export var doors: Array[Door]

func _ready() -> void:
	if is_left:
		left()
	else:
		right()

func left() -> void:
	toogle_doors()
	is_left = true
	animation_player.play("left")
	
func right() -> void:
	toogle_doors()
	is_left = false
	animation_player.play("right")

func toogle_doors() -> void:
	for door in doors:
		door.change_state()
	
