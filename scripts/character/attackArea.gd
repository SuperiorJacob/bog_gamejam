class_name AttackArea extends Area3D

@export var collider: CollisionShape3D
var targetable = false;

func setupArea(size: int):
	var shape = CylinderShape3D.new()
	shape.height = collider.shape.height
	shape.radius = size

	collider.shape = shape

func onPossessionChanged(isPossessed: bool):
	targetable = isPossessed