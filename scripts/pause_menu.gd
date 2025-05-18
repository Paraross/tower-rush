class_name PauseMenu

extends CanvasLayer

signal exited_to_game

func _ready() -> void:
	exit()


func _on_resume_button_pressed() -> void:
	exit_to_game()


func _on_settings_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	get_tree().call_deferred("reload_current_scene")


func exit_to_game() -> void:
	exit()
	exited_to_game.emit()


func exit() -> void:
	set_process_input(false)
	hide()


func enter() -> void:
	set_process_input(true)
	show()
