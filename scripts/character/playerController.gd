class_name PlayerController extends Node3D

@export_group("Movement")
@export var movementDeltaModifier = 100
@export var possessed: Possessable
@export var possessedMaterial: BaseMaterial3D

var input_dir: Vector2

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
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var casted = castMouseToWorld()
	if (!casted): return
	possessed.facePosition(casted.position)

func changePossession(character: CharacterBody3D):
	print("Changing possession")
	if (!character || !is_instance_valid(character)): return

	possessed.stopPossessing()
	possessed.death()
	character.possess(possessedMaterial)
	possessed = character;

func _process(_delta):
	if (Input.is_action_just_pressed("dash")):
		possessed.dash()
	elif (Input.is_action_just_pressed("attack")):
		possessed.attack()
	elif (Input.is_action_just_pressed("second_attack")):
		var casted = castMouseToWorld()
		if (!casted || casted.collider.get_class() != "CharacterBody3D"): return

		changePossession(casted.collider)
