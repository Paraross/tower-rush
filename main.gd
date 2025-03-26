extends Node

@onready var player: Player = $Player
@onready var platforms: Node = $Platforms

func _ready() -> void:
	for platform: Platform in platforms.get_children():
		platform.initialize(player)
