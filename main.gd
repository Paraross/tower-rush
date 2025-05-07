extends Node

const MAX_LEVEL: int = 3

@onready var player: Player = $Player
@onready var background: Sprite2D = $Player/Background
@onready var platforms: Node = $Platforms

var platform_scene: PackedScene = preload("res://platform.tscn")
var platform_sprites: Array[Texture2D]
var current_level: int = 1
var player_starting_pos_x: float

func _process(_delta: float) -> void:
	background.global_position.x = player_starting_pos_x
	var shader: ShaderMaterial = background.material
	shader.set_shader_parameter("player_pos_y", player.position.y)

func _ready() -> void:
	player_starting_pos_x = player.position.x
	load_platform_sprites()
	
	for platform: Platform in platforms.get_children():
		platform.initialize(player, platform_sprites[current_level - 1])


func load_platform_sprites() -> void:
	for i in range(1, MAX_LEVEL + 1):
		var platform_path := "res://assets/level%s/long_platform%s.png" % [i, i]
		var platform_sprite: Texture2D = load(platform_path)
		platform_sprites.append(platform_sprite)


func _on_player_reached_height(count: int) -> void:
	var new_platform: Platform = platform_scene.instantiate()
	new_platform.position.x = 250.0
	new_platform.position.y = 100.0 - (count - 1) * 150.0
	new_platform.initialize(player, platform_sprites[current_level - 1])
	platforms.add_child(new_platform)
