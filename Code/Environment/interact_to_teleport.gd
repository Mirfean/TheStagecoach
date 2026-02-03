extends Interactable_object
class_name Interact_Teleport

@export var PointToTeleport: Node2D
@export var OtherTeleport: Interact_Teleport
@export var PointToSpawn: Node2D
@export var sprite: Texture2D

var playerNode: Node2D

func _ready() -> void:
	active_sprite.texture = sprite

func Interact():
	print("Interact to teleport :>")
	if PointToTeleport == null and OtherTeleport == null:
		print_debug("I have no place to teleport!")
	elif PointToTeleport != null:
		teleportMeHere(PointToTeleport)
	else:
		teleportMeHere(OtherTeleport.PointToSpawn)
	

func teleportMeHere(place: Node2D):
	playerNode.global_position = place.global_position

func _on_body_entered(body: Node2D):
	super._on_body_entered(body)
	if playerNode == null and body is player:
		playerNode = body

func _on_body_exited(body: Node2D):
	super._on_body_exited(body)
