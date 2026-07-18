extends CharacterBody2D

@export var following: Node2D 

func _physics_process(delta: float) -> void:
	
	if following != null:
		if global_position.distance_squared_to(following.global_position) > 10000: # 100²
			var direction := global_position.direction_to(following.global_position)
			velocity += direction * 25
	
	velocity = lerp(velocity, Vector2.ZERO, delta * 5)
	
	move_and_slide()
