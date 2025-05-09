extends Node

const MAX_LEVEL: int = 3

@onready var player: Player = $Player
@onready var background: Sprite2D = $Background
@onready var camera: Camera2D = $Camera2D
@onready var platforms: Node = $Platforms
@onready var left_wall: StaticBody2D = $Walls/LeftWall
@onready var right_wall: StaticBody2D = $Walls/RightWall

var platform_scene: PackedScene = preload("res://platform.tscn")
var platform_sprites: Array[Texture2D]
var current_level: int = 1

var platform_distance: float = 150.0

func _process(_delta: float) -> void:
	set_camera_background_positions()
	
	set_background_shader_parameter()

func _ready() -> void:
	background.position.x = player.position.x
	camera.position.x = player.position.x
	
	load_platform_sprites()
	
	for platform: Platform in platforms.get_children():
		platform.initialize(player, platform_sprites[current_level - 1])


func load_platform_sprites() -> void:
	for i in range(1, MAX_LEVEL + 1):
		var platform_path := "res://assets/level%s/long_platform%s.png" % [i, i]
		var platform_sprite: Texture2D = load(platform_path)
		platform_sprites.append(platform_sprite)


func set_camera_background_positions() -> void:
	camera.position.y = player.position.y
	background.position.y = player.position.y


func set_background_shader_parameter() -> void:
	var shader: ShaderMaterial = background.material
	shader.set_shader_parameter("player_pos_y", player.position.y)


func spawn_next_platform(reach_count: int) -> void:
	var new_platform: Platform = platform_scene.instantiate()
	
	var platform_half_width := new_platform.desired_size.x / 2.0
	var new_platform_x := randf_range(
		left_wall.position.x + platform_half_width,
		right_wall.position.x - platform_half_width,
	)
	var new_platform_y := -250.0 - (reach_count - 1) * platform_distance
	
	new_platform.position.x = new_platform_x
	new_platform.position.y = new_platform_y
	
	new_platform.initialize(player, platform_sprites[current_level - 1])
	platforms.add_child(new_platform)


func _on_player_reached_height(count: int) -> void:
	spawn_next_platform(count)
