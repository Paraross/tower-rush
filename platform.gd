class_name Platform
extends StaticBody2D

var desired_size: Vector2 = Vector2(128.0, 12.0)

# idk if which would be better: Player or the most general type (Node2D)
var player: Node2D
var sprite_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# spawned at the start
	if sprite_texture == null:
		return
	
	var size := sprite_texture.get_size()
	var ratio := desired_size / size
	sprite.scale = ratio
	sprite.texture = sprite_texture


func _process(_delta: float) -> void:
	var player_above_platform := player.position.y < position.y - 3
	set_collision_layer_value(2, player_above_platform)


func initialize(player_node: Player, texture: Texture2D) -> void:
	player = player_node as Node2D
	sprite_texture = texture
