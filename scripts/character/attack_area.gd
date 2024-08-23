class_name AttackArea extends Area3D

@export var collider: CollisionShape3D
@export var targetable = true
var isPossessed = false

func setupArea(size: float):
	var shape = CylinderShape3D.new()
	shape.height = collider.shape.height
	shape.radius = size

	collider.shape = shape

func onPossessionChanged(possessed: bool):
	isPossessed = possessed