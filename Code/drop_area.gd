extends Panel


func _drop_data(at_position: Vector2, data) -> void:
	var item = data as InventoryItem
	print("Siema z dropu od ", item._inventory.name)
	if Inventory_manager.spawn_item_on_ground(item.get_proto_id(), item.get_stack_size()):
		var inv = item.get_inventory()
		inv.remove_item(item)
		print_debug("Yuuuuuuuupi title! ", item.get_title())
	elif Inventory_manager.spawn_item_on_ground(item.get_proto_id(), item.get_stack_size()):
		var inv = item.get_inventory()
		inv.remove_item(item)
		print_debug("Yuuuuuuuupi ID! ", item.get_proto_id())
	else:
		print_debug("Womp womp... ", item.get_title(), " ", item.get_proto_id())

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is InventoryItem
