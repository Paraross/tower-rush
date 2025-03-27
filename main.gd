extends Node

@onready var player: Player = $Player
@onready var platforms: Node = $Platforms

var platform_scene: PackedScene = preload("res://platform.tscn")

func _ready() -> void:
	for platform: Platform in platforms.get_children():
		platform.initialize(player)


func _on_player_reached_height(count: int) -> void:
	var new_platform: Platform = platform_scene.instantiate()
	new_platform.position.x = 250.0
	new_platform.position.y = 100.0 - (count - 1) * 150.0
	new_platform.initialize(player) 
	platforms.add_child(new_platform)
