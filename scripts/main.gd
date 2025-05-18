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
	var screen_size_y: float = get_viewport().get_visible_rect().size.y # <<< POPRAWIONA LINIA
	var initial_danger_zone_y: float = player.position.y + screen_size_y / 2 + 50 # Trochę poniżej widoku
	danger_zone.start_moving(initial_danger_zone_y) # Przekaż pozycję startową
	danger_zone.player_caught.connect(_on_player_caught)
	exit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		exit()
		pause_menu.enter()


func _process(_delta: float) -> void:
	set_camera_background_positions()
	background.set_player_position_in_shader(player.position.y)
	handle_platform_spawning()
	# Sprawdzanie, czy gracz nie spadł poniżej DangerZone
	# (dodatkowe zabezpieczenie, jeśli kolizja Area2D by zawiodła lub dla natychmiastowej reakcji)
	@warning_ignore("unsafe_property_access")
	if player.global_position.y > danger_zone.global_position.y + (danger_zone.get_node("CollisionShape2D").shape.size.y / 2):
		 # Dodajemy połowę wysokości DangerZone, aby upewnić się, że gracz jest faktycznie PONIŻEJ
		if player.is_processing(): # Sprawdź, czy gra nie jest już zakończona/spauzowana
			print("Gracz spadł poniżej DangerZone!")
			_on_player_caught()


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



func _on_player_caught() -> void:
	# Logika końca gry
	print("GAME OVER - Player caught or fell into DangerZone")
	exit() # Zatrzymuje przetwarzanie dla Main i Player
	# Użyj call_deferred do przeładowania scen  
	get_tree().call_deferred("reload_current_scene")



func enter() -> void:
	set_process(true)
	set_process_unhandled_input(true)
	player.set_process(true)
	danger_zone.set_process(true) # Wznów ruch DangerZone


func exit() -> void:
	set_process(false)
	set_process_unhandled_input(false)
	player.set_process(false)
	danger_zone.set_process(false) # Wznów ruch DangerZone


func _on_main_menu_exited_to_game() -> void:
	enter()


func _on_pause_menu_exited_to_game() -> void:
	enter()
