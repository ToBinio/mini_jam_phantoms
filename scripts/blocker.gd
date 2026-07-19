extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	if body.global_position.x > global_position.x:
		body.set_light(false)
	else:
		body.set_light(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	
	if body.global_position.x < global_position.x:
		body.set_light(true)
	else:
		body.set_light(false)
