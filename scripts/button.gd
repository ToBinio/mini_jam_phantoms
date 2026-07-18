extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

@export var is_up: bool = true

@export var doors: Array[Door]

func _physics_process(delta):
	var bodies = area_2d.get_overlapping_bodies()
	
	if bodies.size() > 0:
		if is_up:
			down()
	else:
		if !is_up:
			up()

func _ready() -> void:
	if is_up:
		up()
	else:
		down()

func up() -> void:
	toogle_doors()
	is_up = true
	animation_player.play("up")

func down() -> void:
	toogle_doors()
	is_up = false
	animation_player.play("down")
	
func toogle_doors() -> void:
	for door in doors:
		door.change_state()
