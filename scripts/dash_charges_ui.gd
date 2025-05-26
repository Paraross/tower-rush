class_name DashChargesUI
extends CanvasLayer

@export var empty_color: Color = Color(0.5, 0.5, 0.5, 0.5)
@export var full_color: Color = Color(1, 1, 1, 1)
@export var charging_color: Color = Color(0.8, 0.8, 0.8, 1)
@export var margin: Vector2 = Vector2(20, 20) 
@export var spacing: float = 10 
@export var charge_size: Vector2 = Vector2(30, 6)

@onready var charges: Array[ColorRect] = [$Charge1, $Charge2, $Charge3]

func _ready() -> void:
	var total_width: float = (charge_size.x * charges.size()) + (spacing * (charges.size() - 1))
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
		if i < available:
			charges[i].color = full_color
		elif i == available and progress > 0.0:
			charges[i].color = charging_color.lerp(full_color, progress)
		else:
			charges[i].color = empty_color

func _process(_delta: float) -> void:
	var total_width: float = (charge_size.x * charges.size()) + (spacing * (charges.size() - 1))
	var start_x: float = get_viewport().get_visible_rect().size.x - margin.x - total_width
	
	for i in range(charges.size()):
		charges[i].position.x = start_x + i * (charge_size.x + spacing)
