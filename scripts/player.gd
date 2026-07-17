extends CharacterBody2D


@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		possess_nearby_sprite()
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction*speed, acceleration * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	move_and_slide()


func possess_nearby_sprite():
	shape_cast_2d.force_shapecast_update()
	
	for i in shape_cast_2d.get_collision_count():
		var body = shape_cast_2d.get_collider(i)
		
		if body == self:
			continue
		
		var other_sprite = body.get_node("Sprite2D")
		var my_sprite = $Sprite2D
		
		my_sprite.texture = other_sprite.texture
		my_sprite.flip_h = other_sprite.flip_h
		
		body.queue_free()
		
		global_position = body.global_position
		
		break
