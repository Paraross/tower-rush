extends Node

const MAX_LEVEL: int = 3

@export var coin_scene: PackedScene = preload("res://scenes/coin.tscn")
@export var coin_spawn_chance: float = 0.3
var coin_spawn_height_offset: float = -24.0

@export var bat_scene: PackedScene = preload("res://scenes/bat.tscn")
@export var bat_spawn_chance: float = 0.2
var bat_spawn_height_range: Vector2 = Vector2(-150, -300)  # Zakres Y względem platformy

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
@onready var game_over_menu: GameOverMenu = $GameOverMenu
@onready var background: Background = $Background

@onready var danger_zone: DangerZone = $DangerZone
@onready var score_label: Label = $Camera2D/ScoreLabel

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
	
	init_danger_zone()
	
	exit()


func init_danger_zone() -> void:
	var screen_size_y := get_viewport().get_visible_rect().size.y
	var initial_danger_zone_y := player.position.y + screen_size_y / 2 + 50
	danger_zone.initialize(initial_danger_zone_y)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		exit()
		pause_menu.enter()


func _process(_delta: float) -> void:
	set_camera_background_positions()
	background.set_player_position_in_shader(player.position.y)
	handle_platform_spawning()
	update_score_display()


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
	
	score += int(difficulty_level)
	update_score_display()
	animate_score()


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
	
	if randf() < bat_spawn_chance:
		spawn_bat_near_platform(new_platform)
		
	if randf() < coin_spawn_chance:
		spawn_coin_above_platform(new_platform)
	
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


func spawn_coin_above_platform(platform: Platform) -> void:
	var coin: Coin = coin_scene.instantiate()
	
	var random_horizontal_offset := randf_range(
		-platform.desired_size.x / 5.0,
		platform.desired_size.x / 5.0,
	)
	coin.position = Vector2(
		platform.position.x + random_horizontal_offset,
		platform.position.y + coin_spawn_height_offset,
	)
	
	add_child(coin)
	coin.coin_collected.connect(_on_coin_collected)


func _on_coin_collected(value: int) -> void:
	score += value
	update_score_display()


func update_score_display() -> void:
	score_label.text = str(score)
	

func animate_score() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), 0.1)


func spawn_bat_near_platform(platform: Platform) -> void:
	var bat: Bat = bat_scene.instantiate()
	
	var random_x := randf_range(
		platform.position.x - platform.desired_size.x / 3,
		platform.position.x + platform.desired_size.x / 3
	)
	var random_y := platform.position.y + randf_range(
		bat_spawn_height_range.x,
		bat_spawn_height_range.y
	) 
	bat.position = Vector2(random_x, random_y)
	bat.set_bounds(left_wall.position.x, right_wall.position.x)
	
	var moving_bat_chance := 0.75
	var speed := 0.0
	if randf() < moving_bat_chance:
		var random_speed_mult := randf_range(0.5, 1.5)
		speed = 50.0 * difficulty_level * random_speed_mult
	bat.set_speed(speed)
	
	bat.player_caught.connect(game_over)
	add_child(bat)


func game_over(reason: String) -> void:
	exit()
	player.sprite.animation = "dead"
	game_over_menu.death_reason = reason.to_upper()
	game_over_menu.points = score
	game_over_menu.enter()


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
