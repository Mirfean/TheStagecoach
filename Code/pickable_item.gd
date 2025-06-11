extends Interactable_object
class_name pickable_item

@export var item_display_name : String
@export var item_name : String
@export var item_amount : int = 1

func _init(name : String = "", amount : int = 1, display : String = ""):
	item_name = name
	item_amount = amount
	item_display_name = display

func _ready() -> void:
	var imagePath = Inventory_manager.get_sprite_from_protoset(item_name)
	active_sprite.texture = load(imagePath)
	print("spawn item")

func Interact():
	if Inventory_manager.add_item_from_ground(item_name):
		pick_up()
		return
	print_debug("Not enought space!")

func pick_up():
	print("pick up")
	queue_free()

func _on_body_entered(body: Node2D):
	super._on_body_entered(body)

func _on_body_exited(body: Node2D):
	super._on_body_exited(body)
