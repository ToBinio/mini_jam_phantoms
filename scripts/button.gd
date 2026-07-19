extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

@export var is_up: bool = true

@export var doors: Array[Door]

@onready var down_sound: AudioStreamPlayer2D = $DownSound
@onready var up_sound: AudioStreamPlayer2D = $UpSound

func _physics_process(_delta):
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
	up_sound.play()

func down() -> void:
	toogle_doors()
	is_up = false
	animation_player.play("down")
	down_sound.play()
	
func toogle_doors() -> void:
	for door in doors:
		door.change_state()
