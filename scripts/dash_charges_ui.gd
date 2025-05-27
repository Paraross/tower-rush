class_name DashChargesUI
extends CanvasLayer

@export var empty_color: Color = Color(0.5, 0.5, 0.5, 1)
@export var full_color: Color = Color(1, 1, 1, 1)
@export var margin: Vector2 = Vector2(20, 20) 
@export var spacing: float = 10 
@export var charge_size: Vector2 = Vector2(30, 6)

@onready var charges: Array[ColorRect] = [$Charge1, $Charge2, $Charge3]

func _ready() -> void:
	var total_width: float = charge_size.x * charges.size() + spacing * (charges.size() - 1)
	var start_x: float = get_viewport().get_visible_rect().size.x - margin.x - total_width
	
	for i in range(charges.size()):
		charges[i].size = charge_size
		charges[i].position = Vector2(
			start_x + i * (charge_size.x + spacing),
			margin.y
		)
		charges[i].color = empty_color


func update_charges(available: int, progress: float) -> void:
	for i in range(charges.size()):
		var shader: ShaderMaterial = charges[i].material
		if i < available:
			shader.set_shader_parameter("progress", 1.0)
		elif i == available:
			shader.set_shader_parameter("progress", progress)
		else:
			shader.set_shader_parameter("progress", 0.0)


func set_coin_rush(coin_rush: bool) -> void:
	for i in range(charges.size()):
		var shader: ShaderMaterial = charges[i].material
		shader.set_shader_parameter("in_coin_rush", coin_rush)
