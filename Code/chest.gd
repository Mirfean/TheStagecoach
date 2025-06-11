extends Interactable_object
class_name chest

@export var Items : Dictionary

@onready var closed: Sprite2D = $closed
@onready var opened: Sprite2D = $opened
@onready var collision_shape_2d: CollisionShape2D = $InteractionZone
@onready var openingSound: AudioStreamPlayer2D = $AudioStreamPlayer2D


var first_time = true
var isOpen := false
var isPlayerClose := false

func _ready() -> void:
	super._ready()
	if not isOpen:
		active_sprite = closed
		closed.visible = true
		opened.visible = false
	else:
		active_sprite = opened
		closed.visible = false
		opened.visible = true
	default_material = active_sprite.material


#func _input(event: InputEvent) -> void:
	#if not isPlayerClose:
		#return
	##if (not isOpen) and event.is_action_pressed("Interaction"):
	#if event.is_action_pressed("Interaction"):
		#openChest()

func openChest() -> void:
	if not isOpen:
		closed.visible = false
		opened.visible = true
		isOpen = true
		openingSound.play()
	print("Chest opened!")
	Inventory_manager.open_new_chest(self)
	
func update_chest(dict: Dictionary):
	Items = dict

func Interact():
	super.Interact()
	openChest()

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)

func _on_body_exited(body: Node2D) -> void:
	super._on_body_exited(body)
