extends Node

const MAX_LEVEL: int = 3

var platform_scene: PackedScene = preload("res://scenes/platform.tscn")
var platform_sprites: Array[Texture2D]

var current_level: int = 1
var difficulty_level: float = 1.0

var spawned_platform_count: int = 0
var reach_height: float

var platform_distance: float = 150.0
var initial_platform_pos: float

var score: int = 0

@onready var player: Player = $Player
@onready var camera: Camera2D = $Camera2D
@onready var platforms: Node = $Platforms
@onready var left_wall: StaticBody2D = $Walls/LeftWall
@onready var right_wall: StaticBody2D = $Walls/RightWall
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var background: Background = $Background
@onready var danger_zone: DangerZone = $DangerZone
# TODO: fix jittering. smooth camera on youtube?

func _ready() -> void:
	reach_height = player.position.y - platform_distance
	
	background.position.x = player.position.x
	camera.position.x = player.position.x
	
	@warning_ignore("shadowed_global_identifier")
	var floor: Platform = platforms.get_node("Floor")
	initial_platform_pos = floor.position.y - platform_distance
	
	load_platform_sprites()
	
	for platform: Platform in platforms.get_children():
		platform.initialize(player, platform_sprites[current_level - 1], difficulty_level)
	
	# spawn some platforms ahead
	for i in range(2):
		spawn_next_platform()
	
	# Inicjalizacja DangerZone
	var screen_size_y := get_viewport().get_visible_rect().size.y
	var initial_danger_zone_y := player.position.y + screen_size_y / 2 + 50
	danger_zone.initialize(initial_danger_zone_y)
	exit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		exit()
		pause_menu.enter()


func _process(_delta: float) -> void:
	set_camera_background_positions()
	background.set_player_position_in_shader(player.position.y)
	handle_platform_spawning()


func load_platform_sprites() -> void:
	for i in range(1, MAX_LEVEL + 1):
		var platform_path := "res://assets/level%s/long_platform%s.png" % [i, i]
		var platform_sprite: Texture2D = load(platform_path)
		platform_sprites.append(platform_sprite)


func set_camera_background_positions() -> void:
	camera.position.y = player.position.y
	for background_element: Sprite2D in $Background.get_children():
		background_element.position.y = player.position.y


func handle_platform_spawning() -> void:
	if not player.position.y < reach_height:
		return
	
	spawn_next_platform()
	reach_height -= platform_distance


func spawn_next_platform() -> void:
	var new_platform: Platform = platform_scene.instantiate()
	new_platform.initialize(player, platform_sprites[current_level - 1], difficulty_level)
	
	var platform_half_width := new_platform.desired_size.x / 2.0
	var new_platform_x := randf_range(
		left_wall.position.x + platform_half_width,
		right_wall.position.x - platform_half_width,
	)
	var new_platform_y := initial_platform_pos - spawned_platform_count * platform_distance
	
	new_platform.position = Vector2(new_platform_x, new_platform_y)
	
	platforms.add_child(new_platform)
	
	spawned_platform_count += 1
	# TODO: do this properly
	if spawned_platform_count == 6:
		current_level += 1
		difficulty_level += 1.0
		background.set_sprites(current_level)
		danger_zone.increase_difficulty_speed(150)
	elif spawned_platform_count == 12:
		current_level += 1
		difficulty_level += 1.0
		background.set_sprites(current_level)
		danger_zone.increase_difficulty_speed(220)


### Reason is currently only danger zone.
### Later might include things like time running out.
func game_over(reason: String) -> void:
	print("GAME OVER")
	print("Killed by: %s" % reason)
	exit()
	get_tree().call_deferred("reload_current_scene")


func enter() -> void:
	set_process(true)
	set_process_unhandled_input(true)
	player.set_process(true)
	danger_zone.set_process(true)


func exit() -> void:
	set_process(false)
	set_process_unhandled_input(false)
	player.set_process(false)
	danger_zone.set_process(false)


func _on_main_menu_exited_to_game() -> void:
	enter()


func _on_pause_menu_exited_to_game() -> void:
	enter()
