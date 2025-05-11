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
	
	var pf := ParallaxFactors.based_on_level(level)
	background_shader.set_shader_parameter("parallax_factor", pf.background)
	sides_shader.set_shader_parameter("parallax_factor", pf.sides)
	details_shader.set_shader_parameter("parallax_factor", pf.details)


func set_player_position_in_shader(player_position_y: float) -> void:
	background_shader.set_shader_parameter("player_pos_y", player_position_y)
	sides_shader.set_shader_parameter("player_pos_y", player_position_y)
	details_shader.set_shader_parameter("player_pos_y", player_position_y)


class ParallaxFactors:
	var background: float
	var sides: float
	var details: float
	
	static func based_on_level(level: int) -> ParallaxFactors:
		assert(level >= 1 and level <= 3)
		
		match level:
			1: return level1()
			2: return level2()
			_: return level3()
	
	
	static func level1() -> ParallaxFactors:
		return ParallaxFactors.from_values(0.5, 1.0, 1.5)
	
	
	static func level2() -> ParallaxFactors:
		return ParallaxFactors.from_values(0.5, 1.0, 1.0)
	
	
	static func level3() -> ParallaxFactors:
		return ParallaxFactors.from_values(0.1, 1.0, 1.0)
	
	static func from_values(
		background_f: float,
		sides_f: float,
		details_f: float
	) -> ParallaxFactors:
		var pf := ParallaxFactors.new()
		pf.background = background_f
		pf.sides = sides_f
		pf.details = details_f
		return pf
