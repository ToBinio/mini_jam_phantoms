extends StaticBody2D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_open: bool = true
@onready var audio: AudioStreamPlayer2D = $Audio

func _ready() -> void:
	if is_open:
		open()
	else:
		close()
		
func change_state() -> void:
	if is_open:
		close()
	else: 
		open()

func open() -> void:
	audio.play()
	is_open = true
	animation_player.play("open")

func close() -> void:
	audio.play()
	is_open = false
	animation_player.play("close")
