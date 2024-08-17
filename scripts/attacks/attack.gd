class_name Attack extends Node3D

enum DamageTarget {
	POSSESSED = 1,
	ENEMIES = 2,
	NOT_SELF = 4
}

@export var damage: int = 1
@export_flags("Possessed", "Enemies", "Not Self") var enemyTargets = 0
@export_flags("Possessed", "Enemies", "Not Self") var possessedTargets = 0

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

func doDamageRadius(amount: int, radius: float):
	var damageTarget: int = enemyTargets
	if (character.isPossessed): damageTarget = possessedTargets

	var bitPossessed = Global.bitAnyOf(damageTarget, DamageTarget.POSSESSED)
	var bitEnemies = Global.bitAnyOf(damageTarget, DamageTarget.ENEMIES)
	var bitNotSelf = Global.bitAnyOf(damageTarget, DamageTarget.NOT_SELF)

	if (!character.isPossessed && bitPossessed && !bitEnemies):
		var possessed = (Global.controller.possessed as CharacterController)

		if (global_position.distance_to(possessed.global_position) <= radius):
			possessed.takeDamage(amount);

		return

	# Wtf is this please
	var characters = get_tree().get_nodes_in_group("possessable")
	for c in characters:
		if (global_position.distance_to(c.global_position) <= radius):
			if (bitNotSelf if (c != character) else !bitNotSelf):
				if (bitPossessed && bitEnemies || bitPossessed && c.isPossessed || bitEnemies && !c.isPossessed):
					(c as CharacterController).takeDamage(amount)