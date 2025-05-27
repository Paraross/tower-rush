class_name Coin

extends Area2D

signal coin_collected(value: int)

@export var coin_value: int = 10

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collect_effect: AnimatedSprite2D = $CollectEffect

func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	coin_collected.emit(coin_value)
	collect_effect.show()
	collect_effect.play("default")
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(3.5, 3.5), 0.2)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "scale", Vector2(0.0, 0.0), 0.3)
	
	await collect_effect.animation_finished
	queue_free()
