class_name Player
extends CharacterBody2D

@export var horizontal_move_speed: float = 300.0
@export var gravity_acceleration: float = 1000.0
@export var jump_impulse: float = 550.0

var target_velocity: Vector2 = Vector2.ZERO
var additional_velocity: Vector2 = Vector2.ZERO

var prev_velocity: Vector2 = Vector2.ZERO
var just_jumped: bool = false
var just_started_falling: bool = false

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var wall_bounce_timer: Timer = $WallBounceTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	handle_horizontal_movement()
	handle_gravity(delta)
	handle_jumping()
	handle_animations()
	
	handle_collisions()
	
	manage_state()
	
	set_self_velocity()
	move_and_slide()


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
		just_jumped = true
	else:
		just_jumped = false


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
	if collision == null:
		return
	var collider: CollisionObject2D = collision.get_collider()
	var collider_is_wall := collider.collision_layer == 4
	if collider_is_wall:
		handle_wall_collision()


func handle_wall_collision() -> void:
	if not is_on_floor() and target_velocity.x != 0.0:
		wall_bounce_timer.start()
		additional_velocity.x = -target_velocity.x


func set_self_velocity() -> void:
	velocity = target_velocity
	var ratio := wall_bounce_timer.time_left / wall_bounce_timer.wait_time
	velocity.x = lerpf(target_velocity.x, additional_velocity.x, ratio)


func handle_animations() -> void:
	# INFO: order matters, first indexes take priority
	var handlers_animations := [
		[handle_fall_animation, &"fall"],
		[handle_jump_animation, &"jump"],
		[handle_walk_animation, &"walk"],
		[handle_idle_animation, &"idle"],
	]
	
	sprite.flip_h = velocity.x < 0.0
	for handler_animation: Array in handlers_animations:
		var handler: Callable = handler_animation[0]
		var animation: StringName = handler_animation[1]
		
		var animation_handled: bool = handler.call()
		
		if animation_handled:
			sprite.animation = animation
			sprite.play()
			break


func handle_idle_animation() -> bool:
	return is_on_floor() and velocity.x == 0


func handle_walk_animation() -> bool:
	return is_on_floor() and velocity.x != 0


func handle_jump_animation() -> bool:
	return just_jumped


func handle_fall_animation() -> bool:
	return just_started_falling


func manage_state() -> void:
	manage_falling()
	prev_velocity = velocity


func manage_falling() -> void:
	just_started_falling = prev_velocity.y <= 0.0 and velocity.y > 0.0


func _on_wall_bounce_timer_timeout() -> void:
	additional_velocity = Vector2.ZERO
