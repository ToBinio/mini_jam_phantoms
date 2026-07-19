extends Node2D

@export var target_energy := 0.0
var current_energy := 1.0

@onready var animation_player: AnimationPlayer = $MainAnimationPlayer

func _ready() -> void:
	$Fade_Transition/AnimationPlayer.play("Fade_out")
	current_energy = 0.0
	target_energy = 0.0
	
	animation_player.play("start")
	
	for light in get_tree().get_nodes_in_group("lights"):
		light.energy = target_energy

func _process(delta):
	if( abs(current_energy - target_energy) > 0.05):
		current_energy = lerp(current_energy, target_energy, delta * 3.0)
		
		for light in get_tree().get_nodes_in_group("lights"):
			light.energy = current_energy 
