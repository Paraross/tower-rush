class_name MainMenu

extends CanvasLayer

signal exited_to_game
signal exited_to_skin_select

func _ready() -> void:
	enter()


func _on_play_button_pressed() -> void:
	exit_to_game()


func _on_settings_button_pressed() -> void:
	exit_to_skin_select()


func _on_exit_button_pressed() -> void:
	var tree := get_tree()
	tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	tree.quit()


func exit_to_game() -> void:
	exit()
	exited_to_game.emit()


func exit_to_skin_select() -> void:
	exit()
	exited_to_skin_select.emit()


func exit() -> void:
	set_process_input(false)
	hide()


func enter() -> void:
	set_process_input(true)
	show()
