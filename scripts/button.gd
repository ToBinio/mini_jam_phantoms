extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_up: bool = true

func _ready() -> void:
	if is_up:
		up()
	else:
		down()
		
func _process(delta: float) -> void:
	# debug function
	if Input.is_action_just_pressed("interact"):
		if is_up:
			down()
		else: 
			up()

func up() -> void:
	is_up = true
	animation_player.play("up")

func down() -> void:
	is_up = false
	animation_player.play("down")
