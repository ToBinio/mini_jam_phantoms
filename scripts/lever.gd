extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_left: bool = true

func _ready() -> void:
	if is_left:
		left()
	else:
		right()
		
func _process(delta: float) -> void:
	# debug function
	if Input.is_action_just_pressed("interact"):
		if is_left:
			right()
		else: 
			left()

func left() -> void:
	is_left = true
	animation_player.play("left")

func right() -> void:
	is_left = false
	animation_player.play("right")
