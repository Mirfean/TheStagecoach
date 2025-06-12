extends Panel


func _drop_data(at_position: Vector2, data) -> void:
	var item = data as InventoryItem
	print("Siema z dropu od ", item._inventory.name)
	if Inventory_manager.spawn_item_on_ground(item.get_title()):
		var inv = item.get_inventory()
		inv.remove_item(item)
		print_debug("Yuuuuuuuupi!")
	else:
		print_debug("Womp womp...")

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	return data is InventoryItem
