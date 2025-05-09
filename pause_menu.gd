class_name PauseMenu

extends CanvasLayer

signal pause_menu_exited

func _ready() -> void:
	set_process_input(false)
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		return_to_play()


func _on_resume_button_pressed() -> void:
	return_to_play()


func _on_settings_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	pass


func return_to_play() -> void:
	set_process_input(false)
	hide()
	pause_menu_exited.emit()
	

func enter() -> void:
	set_process_input(true)
	show()
