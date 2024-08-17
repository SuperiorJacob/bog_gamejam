class_name Attack extends Node3D

@export var damage: int = 1

var character: CharacterController
var destroyed = false

func destroy():
	destroyed = true
	queue_free()

func doAttack():
	pass

func doDamage(_character: CharacterController, _amount: int):
	pass

func doDamageArc(_amount: int, _arc: int):
	pass

func doDamageRadius(amount: int, radius: int):
	var characters = get_tree().get_nodes_in_group("possessable")
	for c in characters:
		if (c != character && global_position.distance_to(c.global_position) <= radius):
			(character as CharacterController).takeDamage(amount)