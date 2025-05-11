class_name Platform
extends StaticBody2D

const DEFAULT_SIZE: Vector2 = Vector2(128.0, 12.0)
const DEFAULT_RAND_RANGE_MIN: float = -64.0
const DEFAULT_RAND_RANGE_MAX: float = 64.0

# idk if which would be better: Player or the most general type (Node2D)
var player: Node2D
var sprite_texture: Texture2D
var desired_size: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# spawned at the start
	if sprite_texture == null:
		return
	
	var size := sprite_texture.get_size()
	var ratio := desired_size / size
	sprite.scale = ratio
	sprite.texture = sprite_texture
	
	var new_rect_hitbox := RectangleShape2D.new()
	new_rect_hitbox.size = desired_size
	hitbox.shape = new_rect_hitbox


func _process(_delta: float) -> void:
	var player_above_platform := player.position.y < position.y - 3
	set_collision_layer_value(2, player_above_platform)


func initialize(player_node: Player, texture: Texture2D, difficulty: float) -> void:
	var diff_range_mod := difficulty * 16.0
	var rand_range := randf_range(
		DEFAULT_RAND_RANGE_MIN - diff_range_mod,
		DEFAULT_RAND_RANGE_MAX - diff_range_mod
	)
	desired_size = DEFAULT_SIZE + Vector2(rand_range, 0.0)
	player = player_node as Node2D
	sprite_texture = texture
