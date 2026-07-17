class_name MovingFish
extends CharacterBody2D

@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0
@export var max_movement_distance := 100

@onready var ray_cast_2d: ShapeCast2D = $RayCast2D

@export var target_position := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(target_position)
	
	if global_position.distance_squared_to(target_position) < 625: # 25²
		choose_new_target()
	
	velocity = velocity.move_toward(direction*speed, acceleration * delta)
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true

	move_and_slide()


func choose_new_target():
	var positon = get_location_in_range(PI / 4)
	if(positon != null):
		target_position = positon
		return
		
	positon = get_location_in_range(PI / 3)
	if(positon != null):
		target_position = positon
		return
	
	target_position = get_localtion_full()

func get_location_in_range(angle: float):
	var direction = randf_range(-angle, angle) + velocity.angle()
	var dir = Vector2(cos(direction), sin(direction))
	var distance = randf_range(max_movement_distance / 3.0, max_movement_distance)
	
	ray_cast_2d.target_position = dir * distance
	ray_cast_2d.force_shapecast_update()
	
	if ray_cast_2d.is_colliding():
		return null
	
	return global_position + ray_cast_2d.target_position


func get_localtion_full() -> Vector2:
	var direction = randf_range(0.0, TAU)
	var dir = Vector2(cos(direction), sin(direction))
	var distance = randf_range(max_movement_distance / 3.0, max_movement_distance)

	ray_cast_2d.target_position = dir * distance
	ray_cast_2d.force_shapecast_update()

	if ray_cast_2d.is_colliding():
		var hit = ray_cast_2d.get_collision_point(0)
		return global_position.lerp(hit, 0.5)
	else:
		return global_position + ray_cast_2d.target_position
