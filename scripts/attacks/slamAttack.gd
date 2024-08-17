extends Attack

@export var particle: GPUParticles3D
@export var attackRange: int
@export var slamTime = 0.5

func _ready():
	(particle.draw_pass_1 as CylinderMesh).bottom_radius = attackRange

	particle.finished.connect(animationFinish)

func _process(_delta):
	if (!character):
		destroy()

func doAttack():
	character.meshNode.add_child(self)
	particle.restart()
	await get_tree().create_timer(slamTime).timeout
	if (destroyed): return
	doDamageRadius(damage, attackRange)

func animationFinish():
	destroy()
