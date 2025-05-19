
class_name Coin  
extends Area2D

signal coin_collected(value: int)

@export var coin_value: int = 10

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		coin_collected.emit(coin_value)
		queue_free()
