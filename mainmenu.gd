extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/startbutton.grab_focus()


func _on_startbutton_pressed() -> void:
	get_tree().change_scene("res://test.tscn")


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
