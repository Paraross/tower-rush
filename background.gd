class_name Background

extends Node2D

@onready var background: Sprite2D = $Background
@onready var sides: Sprite2D = $Sides
@onready var details: Sprite2D = $Details
@onready var background_shader: ShaderMaterial = background.material
@onready var sides_shader: ShaderMaterial = sides.material
@onready var details_shader: ShaderMaterial = details.material

func set_sprites(level: int) -> void:
	var sprite_path := ("res://assets/level%s/" % level) + "%s.png"
	
	var background_sprite: Texture2D = load(sprite_path % "background")
	var sides_sprite: Texture2D = load(sprite_path % "sides")
	var details_sprite: Texture2D = load(sprite_path % "details")
	
	background.texture = background_sprite
	sides.texture = sides_sprite
	details.texture = details_sprite


func set_player_position_in_shader(player_position_y: float) -> void:
	background_shader.set_shader_parameter("player_pos_y", player_position_y)
	sides_shader.set_shader_parameter("player_pos_y", player_position_y)
	details_shader.set_shader_parameter("player_pos_y", player_position_y)
