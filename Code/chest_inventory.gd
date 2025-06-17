extends Control
class_name chest_storage

const info_offset: Vector2 = Vector2(50, 0)

@onready var main_backpack_grid: CtrlInventoryGrid = $PanelContainer/TextureRect/PanelContainer/ChestInventoryGrid
@onready var inventory: Inventory = $PanelContainer/Inventory
@onready var grid_constraint: GridConstraint = $PanelContainer/Inventory/GridConstraint

@export var ItemsList: Dictionary

var current_chest : chest

signal chest_closing

func _ready() -> void:
	Inventory_manager.set_chest_ui(self)
	main_backpack_grid.item_mouse_entered.connect(_on_item_mouse_entered)
	main_backpack_grid.item_mouse_exited.connect(_on_item_mouse_exited)
		#spawn_new_items(ItemsList)
		
func _on_item_mouse_entered(item: InventoryItem) -> void:
	%info_text.show()
	%info_text.text = item.get_title() + "\n" + item.get_description()

func activation():
	print(process_mode)
	if process_mode == Node.PROCESS_MODE_DISABLED:
		activate()
	elif process_mode == Node.PROCESS_MODE_INHERIT:
		disactivate()

func activate():
	self.visible = true
	get_parent().visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func disactivate():
	self.visible = false
	get_parent().visible = false
	process_mode = PROCESS_MODE_DISABLED

func _on_item_mouse_exited(_item: InventoryItem) -> void:
	%info_text.hide()
	
func _input(event: InputEvent) -> void:
	if !(event is InputEventMouseMotion):
		return
	%info_text.set_global_position(get_global_mouse_position() + info_offset)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventoryItem

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print("jajco")
	#TODO make it appear on the floor close to the player

func clear_items():
	inventory.clear()

func spawn_new_items(items: Dictionary, first_time: bool):
	clear_items()
	print("spawning")
	var new_item
	if first_time:
		for item in items:
			new_item = inventory.create_and_add_item(item)
			#new_item.set_property(inventory._KEY_STACK_SIZE, items[item])
			new_item.set_stack_size(items[item])
	else:
		inventory.deserialize(items)

func open_chest(opened_chest: chest, dict : Dictionary):
	clear_items()
	spawn_new_items(dict, opened_chest.first_time)
	ItemsList = dict
	current_chest = opened_chest
	
func close_chest():
	current_chest.update_chest(ItemsList)
	activation()


func _on_button_pressed() -> void:
	chest_closing.emit()
