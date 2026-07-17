extends Sprite2D

@export var number_of_sprites: int;

func _ready() -> void:
	var atlas = texture as AtlasTexture
	atlas.region.position.x = 16 * randi_range(0, number_of_sprites - 1);
