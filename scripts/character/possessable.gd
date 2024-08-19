class_name Possessable extends CharacterBody3D

@export var meshNode: MeshInstance3D

var isPossessed = false
var lookatPos
var lookDot

func possess(materialOverride: Material):
  isPossessed = true
  meshNode.material_override = materialOverride

  onPossessionChanged()

func _physics_process(delta: float):
  if (lookatPos):
    lookDot = meshNode.global_transform.origin.direction_to(lookatPos).dot((meshNode.transform.basis * Vector3.FORWARD).normalized())

    if (lookDot != 0):
      meshNode.global_transform = meshNode.global_transform.interpolate_with(meshNode.global_transform.looking_at(lookatPos), delta * 10)

func stopPossessing():
  isPossessed = false
  meshNode.material_override = null

func facePosition(pos: Vector3):
  pos.y = meshNode.global_position.y
  lookatPos = pos

func onPossessionChanged():
  pass
