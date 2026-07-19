extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_animation_player: AnimationPlayer = $"../../../MainAnimationPlayer"

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("trigger end")
	
	area.get_parent().self_destroy()
	await get_tree().create_timer(2).timeout
	
	animation_player.play("open")
	main_animation_player.play("end")
	
