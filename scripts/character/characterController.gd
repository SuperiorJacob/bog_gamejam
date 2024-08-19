class_name CharacterController extends Possessable

@export var characterResource: CharacterResource
@export var triggerArea: AttackArea
@export var dashParticles: GPUParticles3D

var direction: Vector3
var targetInRange = false
var attacking = false

var health = 1
var dashes = 1
var dashing = false

func _ready():
	add_to_group("possessable")

	triggerArea.area_entered.connect(onAreaEntered)
	triggerArea.area_exited.connect(onAreaExited)
	triggerArea.setupArea(characterResource.attackRange)

	reset()

func calculateDirection():
	if (isPossessed):
		var input = Global.controller.input_dir;
		direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized();
	else:
		if (!Global.controller.possessed): return
		var pos = Global.controller.possessed.position
		facePosition(pos)
		direction = position.direction_to(pos);

func _physics_process(delta: float):
	if (!isPossessed && attacking|| health == 0): return

	calculateDirection()

	var speed = delta * Global.controller.movementDeltaModifier * characterResource.moveSpeed;

	velocity.x = direction.x * speed;
	velocity.z = direction.z * speed;

	move_and_slide();

func _process(_delta: float):
	if (isPossessed || !targetInRange || attacking || health == 0): return

	await attack()

func onAttack():
	characterResource.createAttack(self)

func onAttackEnd():
	pass

func reset():
	health = characterResource.health
	dashes = characterResource.dashCount
	attacking = false

func takeDamage(amount: int):
	if (dashing): return

	print("TAKE DAMAGE <", self, "> Health: ", health, "Damage:", amount)

	health -= amount

	if (health < 1):
		health = 0
		death()

func attack():
	if (attacking || health == 0): return
	calculateDirection()

	attacking = true
	onAttack()
	await Global.createTimer(characterResource.attackCooldown)
	attacking = false
	onAttackEnd()

func dash():
	if (dashing): return

	dashing = true
	dashParticles.restart()

	collision_layer = 2
	collision_mask = 2

	velocity.x = direction.x * characterResource.dashStrength;
	velocity.z = direction.z * characterResource.dashStrength;

	move_and_slide();

	await Global.createTimer(0.15)

	collision_layer = 1
	collision_mask = 1
	dashing = false

func onPossessionChanged():
	triggerArea.onPossessionChanged(isPossessed)

	if (isPossessed):
		reset()

func death():
	print("DEATH ", self, " ", health, "/", characterResource.health)

	if (isPossessed):
		return #do something

	health = 0;
	#dissolve shader?
	#await get_tree().create_timer(1).timeout
	queue_free()

func knockback(dir: Vector3, amount: float):
	velocity.x = dir.x * amount
	velocity.z = dir.z * amount

	move_and_slide();

func onAreaEntered(area: AttackArea):
	if (isPossessed || !area.targetable): return

	targetInRange = true

func onAreaExited(area: AttackArea):
	if (isPossessed || !area.targetable): return

	targetInRange = false
