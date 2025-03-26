class_name Platform
extends StaticBody2D

# idk if which would be better: Player or the most general type (Node2D)
var player: Node2D

func _process(_delta: float) -> void:
	var player_above_platform := player.position.y < position.y - 3
	set_collision_layer_value(2, player_above_platform)

 
func initialize(player_node: Player) -> void:
	player = player_node as Node2D
