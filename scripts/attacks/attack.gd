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
var damageTarget: int = enemyTargets

var bitPossessed = false
var bitEnemies = false
var bitNotSelf = false
var isPossessed = false

func _ready():
	isPossessed = character.isPossessed
	if (isPossessed): damageTarget = possessedTargets
	else: damageTarget = enemyTargets

	bitPossessed = Global.bitAnyOf(damageTarget, DamageTarget.POSSESSED)
	bitEnemies = Global.bitAnyOf(damageTarget, DamageTarget.ENEMIES)
	bitNotSelf = Global.bitAnyOf(damageTarget, DamageTarget.NOT_SELF)

func destroy():
	destroyed = true
	queue_free()

func doAttack():
	pass

func shouldDamage(o: Object):
	if (!o.is_in_group("possessable")):
		return false

	var target = (o as CharacterController)
	if (bitNotSelf && target == character): return false

	return (bitPossessed && bitEnemies || bitPossessed && target.isPossessed || bitEnemies && !target.isPossessed)

func doDamage(c: CharacterController, amount: int):
	c.takeDamage(amount)

func doDamageArc(_amount: int, _arc: int):
	pass

func doDamageRadius(amount: int, radius: float):
	if (!isPossessed && bitPossessed && !bitEnemies):
		var possessed = (Global.controller.possessed as CharacterController)

		if (global_position.distance_to(possessed.global_position) <= radius):
			doDamage(possessed, amount)

		return

	var characters = get_tree().get_nodes_in_group("possessable")
	for c in characters:
		if (global_position.distance_to(c.global_position) <= radius && shouldDamage(c)):
			doDamage(c, amount)
