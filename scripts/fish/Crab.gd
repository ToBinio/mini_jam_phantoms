extends CharacterBody2D

@export var speed = 300.0
@export var friction = 800.0
@export var acceleration = 400.0
@export var jump_velocity = -400
@export var visual_scene: PackedScene


@onready var right_cast: RayCast2D = $RightCast
@onready var right_cast_straight: RayCast2D = $RightCastStraight
@onready var left_cast: RayCast2D = $LeftCast
@onready var left_cast_straight: RayCast2D = $LeftCastStraight

var current_visual: Node2D
	
var moving_left: bool

func _ready() -> void:
	moving_left = randf() > 0.5
	current_visual = $Visual

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() / 2 * delta
	
	var direction;
	if moving_left:
		direction = Vector2.LEFT
		if !left_cast.is_colliding() || left_cast_straight.is_colliding():
			moving_left = false
	else:
		direction = Vector2.RIGHT
		if !right_cast.is_colliding() || right_cast_straight.is_colliding():
			moving_left = true
	
	velocity = velocity.move_toward(direction*speed, acceleration * delta)
	
	move_and_slide()
