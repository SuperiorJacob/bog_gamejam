extends ProjectileAttack

@export var timeBeforePop = 0.05;
@export var absolutePopTime = 0.5;
var hit = false

func shouldRicochetFinish():
	return false

func onProjectileHit(obj):
	if (shouldDamage(obj)):
		Global.controller.changePossession(obj)
		hit = true
		return true

	return false

func _process(_delta):
	if (ricochetCount > ricochetAmount):
		await Global.createTimer(timeBeforePop)
		finishTransfer()

func finish():
	super.finish()
	finishTransfer()

func transfer():
	Engine.time_scale = 0.1

	await Global.createTimer(absolutePopTime)

	finishTransfer()

func finishTransfer():
	if (!Global.controller.transferring): return

	Engine.time_scale = 1

	if (!hit):
		Global.controller.createDemonForm(rb.global_position)

	Global.controller.finishTransfer()

func doAttack():
	super.doAttack()

	transfer()