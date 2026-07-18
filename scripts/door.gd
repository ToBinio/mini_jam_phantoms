extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_open: bool = true

func _ready() -> void:
	if is_open:
		open()
	else:
		close()
		
func _process(delta: float) -> void:
	# debug function
	if Input.is_action_just_pressed("interact"):
		if is_open:
			close()
		else: 
			open()

func open() -> void:
	is_open = true
	animation_player.play("open")

func close() -> void:
	is_open = false
	animation_player.play("close")
