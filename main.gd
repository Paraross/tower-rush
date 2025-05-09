extends Node

const MAX_LEVEL: int = 3

@onready var player: Player = $Player
@onready var background: Sprite2D = $Background
@onready var camera: Camera2D = $Camera2D
@onready var platforms: Node = $Platforms

var platform_scene: PackedScene = preload("res://platform.tscn")
var platform_sprites: Array[Texture2D]
var current_level: int = 1

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


func _on_player_reached_height(count: int) -> void:
	var new_platform: Platform = platform_scene.instantiate()
	new_platform.position.x = player.position.x
	new_platform.position.y = -250.0 - (count - 1) * 150.0
	new_platform.initialize(player, platform_sprites[current_level - 1])
	platforms.add_child(new_platform)
