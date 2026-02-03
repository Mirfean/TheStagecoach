extends Control
class_name crafting_menu

@export var Ingredients : Array[ItemSlot]
@export var ResultSlot : ItemSlot
@export var ResultInv : Inventory
@export var craft : Button


signal ItemsChanged
signal CraftTook

func _ready() -> void:
	Inventory_manager.crafting_ui = self
	for slot in Ingredients:
		slot.item_equipped.connect(check_for_craftable)
		slot.cleared.connect(check_for_craftable)
	disactivate()
	
	print(refactor_string("Metal Plate"))

func get_items() -> Array[InventoryItem]:
	var result: Array[InventoryItem] = []
	for item in Ingredients:
		if not item.get_item():
			continue
		result.append(item.get_item())
	return result
	
func to_craft(available_ingr: Array[String]):
	print("Craft ", )
	for proto in ResultInv._prototree.get_prototypes():
		print("Trying to craft ", proto._properties["name"])
		if not proto.has_property("craft"):
			continue
		if can_craft_item(available_ingr, dict_to_array(proto._properties["craft"])):
			var crafted : InventoryItem
			crafted = InventoryItem.new(ResultSlot.protoset, proto._id)
			ResultSlot.equip(crafted)
			#TODO Usuwanie składników względem tej listy dict_to_array(zregexować wszystko i essa)
			return
		

func can_craft_item(available_ingr: Array[String], required_ingr : Array[String]) -> bool:
	var ava_array1: Array[String] = available_ingr.duplicate()
	var req_array2: Array[String] = required_ingr.duplicate()
	ava_array1.sort()
	req_array2.sort()
	print(ava_array1)
	print(req_array2)
	if ava_array1 == req_array2:
		print("I can craft!")
		return true
	else:
		print("I can't :<")
		return false
	
func dict_to_array(items : Dictionary):
	var result_array: Array[String] = []
	for item_name in items.keys():
		var count: int = items[item_name]
		var new_name = refactor_string(item_name)
		for i in range(count):
			result_array.append(new_name)
	return result_array
	
func refactor_string(old_name : String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("[^a-z0-9]")
	old_name = old_name.to_lower()
	var result = regex.sub(old_name, "", true)
	return result

func check_for_craftable(item : InventoryItem = null):
	ResultSlot.clear()
	var items = get_items()
	var available_ingr: Array[String] = []
	for x in items:
		if not x:
			continue
		var iter = 0
		while iter < x.get_stack_size():
			available_ingr.append(refactor_string(x.get_title()))
			iter += 1
	to_craft(available_ingr)

func remove_after_crafted(item : InventoryItem):
	print("Siema")
	#Get list of ingredients required
	var ingr_to_remove = dict_to_array(ResultSlot.get_item().get_property("craft"))
	#Find all that matches from it
	for ingr in Ingredients:
		if not ingr.get_item():
			continue
		print_debug(ingr.name, ingr.get_item().get_stack_size(), ingr_to_remove.count(refactor_string(ingr.get_item().get_proto_id())))
		var item_new_amount = ingr.get_item().get_stack_size() - ingr_to_remove.count(refactor_string(ingr.get_item().get_proto_id()))
		if item_new_amount <= 0:
			ingr.clear()
		else:
			ingr.get_item().set_stack_size(item_new_amount)
	
func craft_item():
	if not ResultSlot.get_item():
		return
	if Inventory_manager.add_InventoryItem_to_main(ResultSlot.get_item()):
		remove_after_crafted(ResultSlot.get_item())
	else:
		print_debug("Womp...")

func activate():
	self.visible = true
	process_mode = PROCESS_MODE_INHERIT
	get_parent().visible = true
	
func disactivate():
	self.visible = false
	process_mode = PROCESS_MODE_DISABLED
	get_parent().visible = false


func _on_craft_pressed() -> void:
	print("CRAFTUJEMY")
	craft_item()


func _on_craft_mouse_entered() -> void:
	print("Halo kurwa")
