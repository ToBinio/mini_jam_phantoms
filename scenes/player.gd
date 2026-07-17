extends CharacterBody2D


@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0


func _physics_process(delta: float) -> void:
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction*speed, acceleration * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
