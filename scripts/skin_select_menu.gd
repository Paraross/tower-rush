extends CanvasLayer

signal exited_to_main_menu

const PALETTE_DIR: StringName = "res://assets/frogs/palettes/"

var green_palette: Texture2D = preload(PALETTE_DIR + "default.png")
var orange_palette: Texture2D = preload(PALETTE_DIR + "orange.png")
var purple_palette: Texture2D = preload(PALETTE_DIR + "purple.png")

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var sprite_palette_shader: ShaderMaterial = player_sprite.material

func _on_green_button_pressed() -> void:
	set_palette(green_palette)


func _on_orange_button_pressed() -> void:
	set_palette(orange_palette)


func _on_purple_button_pressed() -> void:
	set_palette(purple_palette)


func _on_back_button_pressed() -> void:
	exit()
	exited_to_main_menu.emit()


func set_palette(palette: Texture2D) -> void:
	sprite_palette_shader.set_shader_parameter("out_palette", palette)


func exit() -> void:
	set_process_input(false)
	hide()


func enter() -> void:
	set_process_input(true)
	show()
