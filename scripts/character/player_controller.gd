class_name PlayerController extends Node3D

@export_group("Possessor")
@export var possessed: Possessable
@export var possessedMaterial: BaseMaterial3D
@export var possessorBullet: PackedScene
@export var demon: PackedScene

@export_group("Movement")
@export var movementDeltaModifier = 100

var transferring = false
var inputDir: Vector2

func _ready():
	if (!possessed): return
	possessed.possess(possessedMaterial)

func castMouseToWorld():
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * 100000
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [possessed]

	return space_state.intersect_ray(query)

func _physics_process(_delta: float) -> void:
	if (!possessed): return
	inputDir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var casted = castMouseToWorld()
	if (!casted): return
	possessed.facePosition(casted.position)

func changePossession(character: CharacterBody3D):
	if (!character || !is_instance_valid(character)): return

	if (possessed):
		possessed.stopPossessing()
		possessed.death()

	character.possess(possessedMaterial)
	possessed = character;

	# Overlaps get overrided next frame, so push it a frame.
	await Global.nextFrame()

	for c in get_tree().get_nodes_in_group("possessable"):
		c.checkOverlaps()

func _process(_delta):
	if (!possessed): return

	if (Input.is_action_just_pressed("dash")):
		possessed.dash()
	elif (Input.is_action_just_pressed("attack")):
		possessed.attack()
	elif (!transferring && Input.is_action_just_pressed("second_attack")):
		createPosessorAttack()

func playerDeath():
	possessed = null;
	print("Game Over")

func finishTransfer():
	print("Finished transferring")
	transferring = false

func createDemonForm(pos: Vector3):
	var node = demon.instantiate()
	Global.controller.add_child(node)
	node.global_position = pos

	changePossession(node)

	return node

func createPosessorAttack():
	print("Transferring")
	var attackNode = possessorBullet.instantiate()
	attackNode.character = possessed
	attackNode.doAttack()

	transferring = true

	return attackNode
