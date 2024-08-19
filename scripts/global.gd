extends Node

const INT32_MAX = (1 << 31) - 1

var controller: PlayerController
var world: World3D

func _ready():
	var root = get_tree().root
	controller = root.get_child(root.get_child_count() - 1)
	world = get_tree().root.get_world_3d()

func createTimer(time):
	return get_tree().create_timer(time).timeout

func nextFrame():
	return get_tree().create_timer(0).timeout

func simpleRaycast(origin: Vector3, end: Vector3, exclude: Array[RID]):
	var space_state = world.direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = exclude

	return space_state.intersect_ray(query)

func bitAnyOf(needed: int, actual: int):
	return (needed & actual) > 0;

func bitAllOf(needed: int, actual: int):
	return (needed & actual) == needed;

func bitOnlyOf(needed: int, actual: int):
	return (needed == actual);
