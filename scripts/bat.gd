class_name Bat
extends Area2D

signal player_caught(reason: String)

func _ready() -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	player_caught.emit("bat")
