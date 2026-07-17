extends Camera2D

@export var player: Node2D;

func _physics_process(delta: float) -> void:
	position = player.position
