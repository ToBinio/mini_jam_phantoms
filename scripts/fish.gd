extends CharacterBody2D

@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0
@export var movement_area := Vector2(500, 300)

var target_position := Vector2.ZERO

func _ready():
	choose_new_target()

func _physics_process(delta: float) -> void:
	
	var direction := global_position.direction_to(target_position)
	
	if global_position.distance_to(target_position) < 10:
		choose_new_target()
	
	velocity = velocity.move_toward(direction*speed, acceleration * delta)
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true

	move_and_slide()


func choose_new_target():
		target_position = Vector2(
		randf_range(0, movement_area.x),
		randf_range(0, movement_area.y)
	)
