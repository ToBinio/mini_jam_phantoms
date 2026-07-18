extends CharacterBody2D


@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0
@export var jump_velocity = -400.0
@export var push_force = 80.0

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var particles: GPUParticles2D = $Particles

var original_texture: Texture2D
var original_light_energy: float
var original_light_color: Color
var original_light_texture_scale: float

var possessed_body_scene: PackedScene

func _ready() -> void:
	original_texture = $Sprite2D.texture
	original_light_energy = $PointLight2D.energy
	original_light_color = $PointLight2D.color
	original_light_texture_scale = $PointLight2D.texture_scale

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("phantom"):
		if $Sprite2D.texture == original_texture:
			possess_nearby_body()
		else:
			leave_body()
			
	if Input.is_action_just_pressed("interact"):
		for group in get_groups():
			match group.get_basename():
				"Pufferfish":
					pufferfish_ability()
			
	if is_in_group("Crab"):
		if not is_on_floor():
			velocity += get_gravity() / 2 * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity
		
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
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
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)


func possess_nearby_body():
	shape_cast_2d.force_shapecast_update()
	
	for i in shape_cast_2d.get_collision_count():
		var body = shape_cast_2d.get_collider(i)
		
		if body == self:
			continue
		
		var other_sprite = body.get_node("Sprite2D")
		var other_light = body.get_node("PointLight2D")
		var my_sprite = $Sprite2D
		
		remove_from_group("Player")
		
		for group in body.get_groups():
			add_to_group(group)
		
		if body.is_in_group("Pufferfish"):
			possessed_body_scene = preload("res://scenes/pufferfish.tscn")
		elif body.is_in_group("Crab"):
			possessed_body_scene = preload("res://scenes/crab.tscn")
		elif body.is_in_group("Lanternfish"):
			possessed_body_scene = preload("res://scenes/lanternfish.tscn")
		else:
			possessed_body_scene = preload("res://scenes/fish.tscn")
		
		my_sprite.texture = other_sprite.texture
		my_sprite.flip_h = other_sprite.flip_h
		
		if body.is_in_group("Lanternfish"):
			$PointLight2D.color = other_light.color
			$PointLight2D.energy = other_light.energy
			$PointLight2D.texture_scale = other_light.texture_scale
			
		body.queue_free()
		
		global_position = body.global_position
		particles.emitting = false
		
		break
		
func leave_body():
	var new_body = possessed_body_scene.instantiate()
	
	new_body.global_position = global_position
	get_parent().add_child(new_body)
	new_body.get_node("Sprite2D").texture = $Sprite2D.texture
	
	for group in new_body.get_groups():
		remove_from_group(group)
		
	add_to_group("Player")
	
	$Sprite2D.texture = original_texture
	$PointLight2D.color = original_light_color
	$PointLight2D.energy = original_light_energy
	$PointLight2D.texture_scale = original_light_texture_scale
	
	particles.emitting = true
	
func pufferfish_ability():
	shape_cast_2d.force_shapecast_update()
	
	for i in shape_cast_2d.get_collision_count():
		var body = shape_cast_2d.get_collider(i)
		if body == self:
			continue
		
		body.queue_free()
	var new_body = possessed_body_scene.instantiate()
	
	for group in new_body.get_groups():
		remove_from_group(group)
		
	add_to_group("Player")
	
	$Sprite2D.texture = original_texture
