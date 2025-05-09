extends CanvasLayer

func _on_play_button_pressed() -> void:
	hide()


func _on_settings_button_pressed() -> void:
	print("not implemented.")


func _on_exit_button_pressed() -> void:
	var tree := get_tree()
	tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	tree.quit()
