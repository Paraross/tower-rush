class_name Bat

extends Area2D

signal player_caught(reason: String)

var velocity: float
var left_bound: float
var right_bound: float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.animation = "stationary" if velocity == 0.0 else "move"
	sprite.flip_h = velocity < 0.0


func _process(delta: float) -> void:
	position.x += velocity * delta
	if position.x < left_bound:
		position.x = left_bound
		velocity *= -1.0
		sprite.flip_h = false
	elif position.x > right_bound:
		position.x = right_bound
		velocity *= -1.0
		sprite.flip_h = true


func set_bounds(left: float, right: float) -> void:
	left_bound = left
	right_bound = right


func set_speed(speed: float) -> void:
	var random_direction := (randi_range(0, 1) * 2 - 1) as float
	velocity = speed * random_direction


func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	player_caught.emit("bat")
