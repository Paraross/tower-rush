class_name MainMenu

extends CanvasLayer

signal exited_to_game

func _ready() -> void:
	enter()

func _on_play_button_pressed() -> void:
	exit_to_game()


func _on_settings_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	var tree := get_tree()
	tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	tree.quit()


func exit_to_game() -> void:
	set_process_input(false)
	exited_to_game.emit()
	hide()


func enter() -> void:
	set_process_input(true)
	show()


func _on_pause_menu_exited_to_main_menu() -> void:
	enter()
