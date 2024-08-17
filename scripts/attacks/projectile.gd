class_name ProjectileAttack extends Attack

@export var rb: RigidBody3D
@export var ricochet = false
@export var ricochetAmount = 0
@export var projectileStrength = 0

func _ready():
	rb.body_entered.connect(onCollide)

func onCollide(obj):
	var ray = Global.simpleRaycast(position, obj.position, [self])
	print(ray)

func doAttack():
	#character.meshNode.add_child(self)
	Global.controller.add_child(self)
	global_position = character.global_position
	global_rotation = character.meshNode.global_rotation

	var dir = (character.meshNode.transform.basis * Vector3.FORWARD).normalized()

	rb.add_constant_central_force(dir * projectileStrength)