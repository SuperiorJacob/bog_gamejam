class_name CharacterResource extends Resource

@export_group("Basic")
@export var health: int = 1
@export var moveSpeed: int = 10;
@export var moveFriction: int = 1;
@export var dashCount: int = 1
@export var dashStrength: int = 500

@export_group("Attack")
## How far away do we have to be before we attack a player
@export var attackRange: float = 3
## How long before we can resume actions again
@export var attackCooldown: float = 0.5
## Attack system
@export var attack: PackedScene

func createAttack(character: CharacterController):
  if (!attack): return null
  var attackNode = attack.instantiate()
  attackNode.character = character
  attackNode.doAttack()

  return attackNode
