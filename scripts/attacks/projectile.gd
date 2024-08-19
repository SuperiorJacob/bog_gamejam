class_name ProjectileAttack extends Attack

@export var rb: RigidBody3D
@export var ricochet = false
@export var ricochetAmount = 0
@export var projectileStrength = 0
@export var projectileKnockback = 0

var ricochetCount = 0
var direction: Vector3
var startingRotation: Vector3

func _ready():
	super._ready()
	rb.body_entered.connect(onCollide)

func doRicochet(normal: Vector3):
	if (ricochetCount >= ricochetAmount): return finish()
	ricochetCount += 1

	rb.angular_velocity = Vector3.ZERO
	rb.linear_velocity = Vector3.ZERO

	var reflect = direction.bounce(normal)
	direction = reflect

	faceAndMove()

func faceAndMove():
	rb.look_at(rb.global_transform.origin + direction, Vector3.RIGHT)
	rb.rotation += startingRotation

	rb.apply_central_impulse(direction * projectileStrength)

func onCollide(obj):
	var ray = Global.simpleRaycast(position, obj.position, [self])

	if (shouldDamage(obj)):
		#if (ray && projectileKnockback > 0): obj.knockback(-ray.normal, projectileKnockback)
		doDamage(obj, damage)
		return finish()

	if (ray && ricochet): doRicochet(ray.normal)
	else: finish()

func finish():
	queue_free()

func _physics_process(_delta):
	if (rb.linear_velocity.length() == 0): return

	if (rb.linear_velocity.length() < 5): finish()

func doAttack():
	#character.meshNode.add_child(self)
	Global.controller.add_child(self)
	global_position = character.global_position

	startingRotation = rb.rotation
	direction = (character.meshNode.transform.basis * Vector3.FORWARD).normalized()

	position += direction * 2

	faceAndMove()
