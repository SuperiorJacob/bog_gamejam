class_name Possessable extends CharacterBody3D

@export var meshNode: MeshInstance3D

var isPossessed = false

func possess(materialOverride: Material):
  isPossessed = true
  meshNode.material_override = materialOverride

  onPossessionChanged()

func stopPossessing():
  isPossessed = false
  meshNode.material_override = null

func facePosition(pos: Vector3):
  pos.y = position.y
  meshNode.look_at(pos)

func onPossessionChanged():
  pass