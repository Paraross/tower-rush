class_name MainMenu

extends CanvasLayer

signal main_menu_exited

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		exit_to_play()


func _on_play_button_pressed() -> void:
	exit_to_play()


func _on_settings_button_pressed() -> void:
	print("not implemented.")


func _on_exit_button_pressed() -> void:
	var tree := get_tree()
	tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	tree.quit()


func exit_to_play() -> void:
	set_process_input(false)
	main_menu_exited.emit()
	hide()
