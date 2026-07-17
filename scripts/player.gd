extends CharacterBody2D


@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

var original_texture: Texture2D

var possessed_body_scene: PackedScene

func _ready() -> void:
	original_texture = $Sprite2D.texture

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		if $Sprite2D.texture == original_texture:
			possess_nearby_body()
		else:
			leave_body()
	
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


func possess_nearby_body():
	shape_cast_2d.force_shapecast_update()
	
	for i in shape_cast_2d.get_collision_count():
		var body = shape_cast_2d.get_collider(i)
		
		if body == self:
			continue
		
		var other_sprite = body.get_node("Sprite2D")
		var my_sprite = $Sprite2D
		
		possessed_body_scene = preload("res://scenes/fish.tscn")
		
		my_sprite.texture = other_sprite.texture
		my_sprite.flip_h = other_sprite.flip_h
		
		body.queue_free()
		
		global_position = body.global_position
		
		break
		
func leave_body():
	var new_body = possessed_body_scene.instantiate()
	
	new_body.global_position = global_position
	get_parent().add_child(new_body)
	new_body.get_node("Sprite2D").texture = $Sprite2D.texture
	
	$Sprite2D.texture = original_texture
