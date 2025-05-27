# TODO ANIMATION AND BETTER INCREASING LOGIC
class_name DangerZone

extends Area2D

signal player_caught(reason: String)

@export var enabled: bool = true
@export var initial_speed: float = 100.0
@export var max_speed: float = 250.0

var current_speed: float = initial_speed

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not enabled:
		return
	
	position.y -= current_speed * delta


func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	player_caught.emit("danger zone")


func initialize(start_position_y: float) -> void:
	position.y = start_position_y


func increase_difficulty_speed(new_base_speed: float) -> void:
	# needs better logic
	initial_speed = new_base_speed
	current_speed = min(initial_speed, max_speed) # Przykład bardziej złożonego skalowania
