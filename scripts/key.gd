extends CharacterBody2D

@export var following: Node2D 
@onready var area_2d: Area2D = $Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var keys_sound: AudioStreamPlayer2D = $KeysSound

func _physics_process(delta: float) -> void:
	
	if following != null:
		if global_position.distance_squared_to(following.global_position) > 10000: # 100²
			var direction := global_position.direction_to(following.global_position)
			velocity += direction * 25
	
	velocity = lerp(velocity, Vector2.ZERO, delta * 5)
	
	move_and_slide()

func self_destroy():
	following = null
	animation_player.play("destroy")
	
	await animation_player.animation_finished
	
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if following or body is not Player:
		return
		
	keys_sound.play()
	following = body
