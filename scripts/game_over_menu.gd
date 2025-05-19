class_name GameOverMenu

extends CanvasLayer

var death_reason: String:
	set(value):
		death_reason_label.text = value

var points: int:
	set(value):
		points_label.text = "%s POINTS" % value

@onready var death_reason_label: Label = $GameOverLabel/MessageLabel/DeathReasonLabel
@onready var points_label: Label = $GameOverLabel/ScoreLabel/ScorePointsLabel

func _ready() -> void:
	exit()


func _on_play_again_button_pressed() -> void:
	pass


func _on_main_menu_button_pressed() -> void:
	get_tree().call_deferred("reload_current_scene")


func _on_exit_button_pressed() -> void:
	var tree := get_tree()
	tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	tree.quit()


func exit() -> void:
	set_process_input(false)
	hide()


func enter() -> void:
	set_process_input(true)
	show()
