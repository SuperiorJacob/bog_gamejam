extends Node

var controller: PlayerController

func _ready():
	var root = get_tree().root
	controller = root.get_child(root.get_child_count() - 1)