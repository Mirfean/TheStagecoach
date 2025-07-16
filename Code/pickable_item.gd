extends Interactable_object
class_name pickable_item

@export var item_id_name : String
@export var item_description : String
@export var item_name : String
@export var item_amount : int = 1
@export var item_1_size : Vector2i


func _init(item_name_param : String = "", amount : int = 1, display : String = ""):
	item_name = item_name_param
	item_amount = amount
	item_description = display
	
func set_values(inv_item : InventoryItem):
	item_id_name = inv_item.get_proto_id()
	item_description = inv_item.get_description()
	item_name = inv_item.get_title()
	item_amount = inv_item.get_stack_size()
	set_new_sprite(inv_item.get_property("image"), inv_item.get_property("size"))

func _ready() -> void:
	if item_id_name != "":
		var imagePath = Inventory_manager.get_property_from_protoset(item_id_name, "image")
		set_new_sprite(imagePath, Inventory_manager.get_property_from_protoset(item_id_name, "size"))
	else:
		print_debug("NIE DZIALA")

func Interact():
	if Inventory_manager.add_item_from_ground(self):
		pick_up()
		return
	print_debug("Not enought space!")

func pick_up():
	print("pick up")
	queue_free()
	
func set_new_sprite(path : String, size : Vector2i):
	var newImage = load(path) as Texture2D
	active_sprite.texture = newImage
	set_sprite_size(newImage, size)
	
	
func set_sprite_size(new_texture: Texture2D, size : Vector2i):
	var newImageSize = new_texture.get_size()
	active_sprite.scale = Vector2(item_1_size.x * size.x / newImageSize.x, item_1_size.y * size.y / newImageSize.y)
	if size.x == 1 and size.y == 1:
		active_sprite.scale *= 2

func _on_body_entered(body: Node2D):
	super._on_body_entered(body)

func _on_body_exited(body: Node2D):
	super._on_body_exited(body)
