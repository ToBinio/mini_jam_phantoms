extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0
@export var jump_velocity = -400.0
@export var push_force = 0.0
@export var visual_scene: PackedScene
var possessed_body_scene: PackedScene

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var label: Label = $"../CanvasLayer/Control/Label"
@onready var time: Label = $"../CanvasLayer/Control/Time"
@onready var timer: Timer = $Timer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var rock_explosion_particles: PackedScene
@export var pufferfish_explosion_particles: PackedScene

@onready var camera: Camera = %Camera2D

var original_visual_scene: PackedScene
var original_visual: Node2D
var current_visual: Node2D
var original_collision_shape: Shape2D
var original_collision_layer: int
var original_collision_mask: int

var is_possessing := false

func _ready() -> void:
	original_visual_scene = visual_scene
	current_visual = $Visual
	original_visual = $Visual
	original_collision_shape = $CollisionShape2D.shape
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask
	
	timer.wait_time = 25;
	timer.start()

func _physics_process(delta: float) -> void:
	if !is_possessing:
		time.text = str(int(ceil(timer.time_left)))
	else:
		time.text = ""
		
	if Input.is_action_just_pressed("phantom"):
		if !is_possessing:
			possess_nearby_body()
		else:
			leave_body()

			
	if Input.is_action_just_pressed("interact"):
		for group in get_groups():
			match group.get_basename():
				"Pufferfish":
					pufferfish_ability()
				"Crab":
					crab_ability()
			
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
			current_visual.get_node("Sprite2D").flip_h = false
		elif velocity.x < 0:
			current_visual.get_node("Sprite2D").flip_h = true
	
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
		
		remove_from_group("Player")
		
		for group in body.get_groups():
			match group.get_basename():
				"Pufferfish":
					push_force = 50.0
					label.text = "Can explode and destroy unstable structure"
					possessed_body_scene = preload("res://scenes/fish/pufferfish.tscn")
				"Crab":
					push_force = 80.0
					label.text = "Can jump and interact with certain objects"
					possessed_body_scene = preload("res://scenes/fish/crab.tscn")
				"Lanternfish":
					push_force = 10.0
					label.text = "Can light out the way"
					possessed_body_scene = preload("res://scenes/fish/lanternfish.tscn")
				"FishRed":
					push_force = 30.0
					label.text = "Can Swim"
					possessed_body_scene = preload("res://scenes/fish/fish_red.tscn")
				"FishBlue":
					push_force = 30.0
					label.text = "Can Swim"
					possessed_body_scene = preload("res://scenes/fish/fish_blue.tscn")
				"Lever":
					return
				"ExplodableRocks":
					return
			add_to_group(group)

		timer.stop()

		$CollisionShape2D.shape = body.get_node("CollisionShape2D").shape
		collision_layer = body.collision_layer
		collision_mask = body.collision_mask

		change_visual(body.visual_scene)
		
		is_possessing = true
		
		global_position = body.global_position
		
		body.queue_free()
		
		break
		
func leave_body():
	timer.wait_time = 10;
	timer.start()
	
	var new_body = possessed_body_scene.instantiate()
	
	new_body.global_position = global_position
	get_parent().add_child(new_body)
	
	for group in new_body.get_groups():
		remove_from_group(group)
		
	change_visual(original_visual_scene)
	
	$CollisionShape2D.shape = original_collision_shape
	collision_layer = original_collision_layer
	collision_mask = original_collision_mask
	push_force = 0.0
	
	is_possessing = false
	
	label.text = ""
	add_to_group("Player")
	
func change_visual(new_visual_scene: PackedScene):
	if is_instance_valid(current_visual):
		current_visual.queue_free()

	current_visual = new_visual_scene.instantiate()

	add_child(current_visual)

	
	
func pufferfish_ability():
	timer.start()
	
	var shock_wave = pufferfish_explosion_particles.instantiate()
	shock_wave.global_position = global_position
	get_parent().add_child(shock_wave)
	
	await get_tree().create_timer(0.2).timeout
	
	shape_cast_2d.force_shapecast_update()
	camera.screen_shake(8, 0.5)
	
	for i in shape_cast_2d.get_collision_count():
		var body = shape_cast_2d.get_collider(i)
		
		if body == self:
			continue
		
		for group in body.get_groups():
			if group == "ExplodableRocks":
				var particles = rock_explosion_particles.instantiate()
				particles.global_position = body.global_position
				get_parent().add_child(particles)
				body.queue_free()
		
	var new_body = possessed_body_scene.instantiate()
	
	for group in new_body.get_groups():
		remove_from_group(group)
		
	change_visual(original_visual_scene)
	
	$CollisionShape2D.shape = original_collision_shape
	
	is_possessing = false
	
	label.text = ""
	add_to_group("Player")
	
func crab_ability():
	shape_cast_2d.force_shapecast_update()
	
	for i in shape_cast_2d.get_collision_count():
		var body = shape_cast_2d.get_collider(i)
		
		if body == self:
			continue
		
		for group in body.get_groups():
			if body.is_in_group("Lever"):
				if body.is_left:
					body.right()
				else:
					body.left()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

var light_on = true
func set_light(off: bool) -> void:
	if off:
		if light_on:
			light_on = false
			animation_player.play("light_out")
	else:
		if !light_on:
			light_on = true
			animation_player.play("light_on")
