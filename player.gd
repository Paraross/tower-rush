class_name Player
extends CharacterBody2D

signal reached_height(count: int)

@export var gravity_acceleration: float = 1000.0
@export var jump_impulse: float = 550.0
@export var horizontal_move_speed: float = 100.0

var target_velocity: Vector2 = Vector2.ZERO
var reach_count: int = 0
var override_horizontal_velocity: bool = false

@onready var reach_height: float = position.y - 150.0
@onready var velocity_override_timer: Timer = $VelocityOverrideTimer

func _process(delta: float) -> void:
	var on_floor := is_on_floor()
	
	var direction := Vector2.ZERO
	
	if on_floor:
		override_horizontal_velocity = false
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1.0
	if Input.is_action_pressed("move_right"):
		direction.x += 1.0
	if not override_horizontal_velocity:
		target_velocity.x = direction.x * horizontal_move_speed
	
	if not on_floor:
		target_velocity.y += gravity_acceleration * delta
	else:
		target_velocity.y = 0.0
	
	if can_jump() and Input.is_action_pressed("jump"):
		jump()
	
	var collision := get_last_slide_collision()
	if collision != null:
		var collider: CollisionObject2D = collision.get_collider()
		var collider_is_wall := collider.collision_layer == 4
		if collider_is_wall and not on_floor and target_velocity.x != 0.0:
			#print("wall hit : %s" % target_velocity)
			override_horizontal_velocity = true
			velocity_override_timer.start()
			target_velocity.x *= -1.0
	
	velocity = target_velocity
	move_and_slide()

	if position.y < reach_height:
		reach_height -= 150.0
		reach_count += 1
		reached_height.emit(reach_count)


func can_jump() -> bool:
	#var collision := get_last_slide_collision()
	#if collision == null:
		#return false
	#if collision.get_angle() >= PI / 2.0:
		#return false
	#var collider: CollisionObject2D = collision.get_collider()
	#return collider.collision_layer == 2
	
	return is_on_floor()


func jump() -> void:
	#print("jump")
	target_velocity.y = -jump_impulse


func _on_velocity_override_timer_timeout() -> void:
	override_horizontal_velocity = false
