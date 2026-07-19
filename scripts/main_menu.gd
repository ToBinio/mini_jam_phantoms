extends Control

var button_type = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	button_type = "start"
	$Fade_Transition.show()
	$Fade_Transition/FadeTimer.start()
	$Fade_Transition/AnimationPlayer.play("Fade_in")
	


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	match button_type:
		"start":
			get_tree().change_scene_to_file("res://scenes/main.tscn")
