class_name Player
extends CharacterBody2D

signal reached_height(count: int)

@export var gravity_acceleration: float = 1000.0
@export var jump_impulse: float = 550.0
@export var horizontal_move_speed: float = 200.0

var target_velocity: Vector2 = Vector2.ZERO
var reach_count: int = 0
var additional_velocity: Vector2 = Vector2.ZERO

@onready var reach_height: float = position.y - 150.0
@onready var wall_bounce_timer: Timer = $WallBounceTimer

func _process(delta: float) -> void:
	handle_horizontal_movement()
	handle_gravity(delta)
	handle_jumping()
	
	handle_collisions()
	
	set_self_velocity()
	move_and_slide()
	
	handle_platform_spawning()


func handle_horizontal_movement() -> void:
	var direction := 0.0
	if Input.is_action_pressed("move_left"):
		direction -= 1.0
	if Input.is_action_pressed("move_right"):
		direction += 1.0
	target_velocity.x = direction * horizontal_move_speed


func handle_jumping() -> void:
	if can_jump() and Input.is_action_pressed("jump"):
		jump()


func can_jump() -> bool:
	return is_on_floor()


func jump() -> void:
	target_velocity.y = -jump_impulse


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		target_velocity.y += gravity_acceleration * delta
	else:
		target_velocity.y = 0.0


func handle_collisions() -> void:
	var collision := get_last_slide_collision()
	if collision != null:
		var collider: CollisionObject2D = collision.get_collider()
		var collider_is_wall := collider.collision_layer == 4
		if collider_is_wall:
			handle_wall_collision(collider)


func handle_wall_collision(_collider: CollisionObject2D) -> void:
	if not is_on_floor() and target_velocity.x != 0.0:
		wall_bounce_timer.start()
		additional_velocity.x = -target_velocity.x


func set_self_velocity() -> void:
	velocity = target_velocity
	var ratio := wall_bounce_timer.time_left / wall_bounce_timer.wait_time
	velocity.x = target_velocity.x * (1.0 - ratio) + additional_velocity.x * ratio


func handle_platform_spawning() -> void:
	if position.y < reach_height:
		reach_height -= 150.0
		reach_count += 1
		reached_height.emit(reach_count)


func _on_wall_bounce_timer_timeout() -> void:
	additional_velocity = Vector2.ZERO
