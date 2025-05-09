class_name PauseMenu

extends CanvasLayer

signal exited_to_game
signal exited_to_main_menu

func _ready() -> void:
	exit()


func _on_resume_button_pressed() -> void:
	exit_to_game()


func _on_settings_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	exit_to_main_menu()


func exit_to_game() -> void:
	exit()
	exited_to_game.emit()


func exit_to_main_menu() -> void:
	exit()
	exited_to_main_menu.emit()


func exit() -> void:
	set_process_input(false)
	hide()


func enter() -> void:
	set_process_input(true)
	show()
