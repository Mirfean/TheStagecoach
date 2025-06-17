extends Control
class_name user_inventory

const info_offset: Vector2 = Vector2(50, 0)

@export var Player : player
@export var weapon_bundle : WeaponBundle

@onready var main_backpack_grid: CtrlInventoryGrid = $"Backpack/Main panel/mainBackpackGrid"
@onready var left_backpack_grid: CtrlInventoryGrid = $"Backpack/Lewy panel/leftBackpackGrid"
@onready var right_backpack_grid: CtrlInventoryGrid = $"Backpack/Prawy panel/rightBackpackGrid"

@onready var main_kieszen: Inventory = $"Inventories/Main kieszen"
@onready var lewa_kieszonka: Inventory = $"Inventories/Lewa kieszonka"
@onready var prawa_kieszonka: Inventory = $"Inventories/Prawa kieszonka"

@onready var weapon_left_hand: CtrlItemSlot = $Panel/Weapon_left_hand
@onready var weapon_right_hand: CtrlItemSlot = $Panel/Weapon_right_hand

var inv_grids : Array[CtrlInventoryGrid]
var current_selected_inventory: CtrlInventoryGrid
var inv_list : Array[Inventory]

signal weapon_left_change
signal weapon_right_change

func _ready() -> void:
	
	Inventory_manager.user_inv = self
	
	if not Player:
		Player = get_tree().get_first_node_in_group("player")
	
	main_backpack_grid.item_mouse_entered.connect(_on_item_mouse_entered)
	main_backpack_grid.item_mouse_exited.connect(_on_item_mouse_exited)
	left_backpack_grid.item_mouse_entered.connect(_on_item_mouse_entered)
	left_backpack_grid.item_mouse_exited.connect(_on_item_mouse_exited)
	right_backpack_grid.item_mouse_entered.connect(_on_item_mouse_entered)
	right_backpack_grid.item_mouse_exited.connect(_on_item_mouse_exited)
	
	main_backpack_grid.inventory_item_selected.connect(_item_selected)
	left_backpack_grid.inventory_item_selected.connect(_item_selected)
	right_backpack_grid.inventory_item_selected.connect(_item_selected)
	
	%SplitLeft.pressed.connect(_on_btn_split.bind(left_backpack_grid))
	%SplitMain.pressed.connect(_on_btn_split.bind(main_backpack_grid))
	%SplitRight.pressed.connect(_on_btn_split.bind(right_backpack_grid))
	
	inv_grids.append(main_backpack_grid)
	inv_grids.append(left_backpack_grid)
	inv_grids.append(right_backpack_grid)
	
	inv_list.append(main_kieszen)
	inv_list.append(lewa_kieszonka)
	inv_list.append(prawa_kieszonka)
	
	activation()

func _on_item_mouse_entered(item: InventoryItem) -> void:
	%info_text.show()
	%info_text.text = item.get_title() + "\n" + item.get_description()

func activation():
	print(process_mode)
	if process_mode == Node.PROCESS_MODE_DISABLED:
		self.visible = true
		process_mode = Node.PROCESS_MODE_INHERIT
		get_parent().visible = true
	elif process_mode == Node.PROCESS_MODE_INHERIT:
		self.visible = false
		process_mode = PROCESS_MODE_DISABLED
		get_parent().visible = false
		
func activate():
	self.visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	get_parent().visible = true
	
func disactivate():
	self.visible = false
	process_mode = PROCESS_MODE_DISABLED
	get_parent().visible = false

func _on_item_mouse_exited(_item: InventoryItem) -> void:
	%info_text.hide()

func _input(event: InputEvent) -> void:
	%info_text.set_global_position(get_global_mouse_position() + info_offset)
	if event.is_action_pressed("Rotate_Item") and current_selected_inventory:
		if current_selected_inventory.get_selected_inventory_item():
			print("rotating ", current_selected_inventory.inventory.grid_constraint.name)
			current_selected_inventory.inventory.grid_constraint.rotate_item(current_selected_inventory.get_selected_inventory_item())
		

func _on_btn_split(ctrl_inventory) -> void:
	var selected_items: Array[InventoryItem] = ctrl_inventory.get_selected_inventory_items()
	if selected_items.is_empty():
		return

	for selected_item in selected_items:
		var stack_size = selected_item.get_stack_size()
		if stack_size < 2:
			return

		# All this floor/float jazz just to do integer division without warnings
		var new_stack_size: int = floor(float(stack_size) / 2)
		ctrl_inventory.inventory.split_stack(selected_item, new_stack_size)

func _on_btn_unequip() -> void:
	#TODO work with different ItemSlots
	#main_backpack_grid.add_item(%CtrlItemSlot.item_slot.get_item())
	print("Zdejmuję dupę")

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventoryItem


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print("jajco")
	#TODO make it appear on the floor close to the player
	
func _item_selected(invItem: InventoryItem):
	print(invItem.get_inventory().name)
	for x in inv_grids:
		if x.inventory.name == invItem.get_inventory().name:
			current_selected_inventory = x
			continue
		x.deselect_inventory_items()

func spawn_new_item_inventoryItem(item : InventoryItem):
	main_kieszen.create_and_add_item(item.get_title())
	
func spawn_new_item_name(itemTitle : String, amount : int = 1):
	main_kieszen.create_and_add_item(itemTitle, amount)
	
func get_weapon_from_bundle(id : int):
	for weapon in weapon_bundle.weapons:
		if weapon.id == id:
			return weapon
	print_debug("Weapon not found!")

func _on_weapon_left_item_equipped() -> void:
	set_weapon_to_hand(0, weapon_left_hand)


func _on_weapon_right_item_equipped() -> void:
	set_weapon_to_hand(1, weapon_right_hand)


func set_weapon_to_hand(hand_id : int, itemSlot : CtrlItemSlot):
	var new_invItem := itemSlot.item_slot.get_item()
	var new_weapon
	if not new_invItem:
		new_weapon = get_weapon_from_bundle(0)
	else:
		new_weapon = get_weapon_from_bundle(new_invItem.get_ID())
	if not new_weapon:
		print_debug("Ale chujnia")
		return
	Player.weapons[hand_id] = new_weapon
	Player.set_weapon(Player.weapon_index)

func _on_weapon_left_cleared(item: InventoryItem) -> void:
	set_weapon_to_hand(0, weapon_left_hand)

func _on_weapon_right_cleared(item: InventoryItem) -> void:
	set_weapon_to_hand(1, weapon_right_hand)

func find_item(item : String, amount : int = 1) -> InventoryItem:
	print("dupa")
	for inv in inv_list:
		var current_item = inv.get_item_with_title(item)
		if current_item:
			if current_item.get_property("stack_size") >= amount:
				return inv.get_item_with_title(item)
			else:
				print("za mało...")
	return null

func remove_item(inv_item: InventoryItem, amount : int):
	print("dupa 2")
	var current_amount = inv_item.get_property("stack_size")
	if current_amount > amount:
		inv_item.set_property("stack_size", current_amount - amount)
	elif current_amount == amount:
		var inv = inv_item.get_inventory()
		inv.remove_item(inv_item)
	else:
		print_debug("We shouldn't be there...")
