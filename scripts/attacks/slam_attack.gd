extends Attack

@export var particle: GPUParticles3D
@export var attackRadius: float = 4
@export var slamTime = 0.5

func _ready():
	super._ready()
	(particle.draw_pass_1 as CylinderMesh).bottom_radius = attackRadius

	particle.finished.connect(animationFinish)

func _process(_delta):
	if (!character):
		destroy()

func doAttack():
	character.meshNode.add_child(self)
	particle.restart()
	await Global.createTimer(slamTime)
	if (destroyed): return
	doDamageRadius(damage, attackRadius/2)

func animationFinish():
	destroy()
