extends Node

@onready var player: Player = $Player

func _ready() -> void:
	$Floor.initialize(player)
	$Floor2.initialize(player)
	$Floor3.initialize(player)
