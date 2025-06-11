extends Control

const info_offset: Vector2 = Vector2(50, 0)

func _ready() -> void:
	%CtrlInventoryGridLeft.item_mouse_entered.connect(_on_item_mouse_entered)
	%CtrlInventoryGridLeft.item_mouse_exited.connect(_on_item_mouse_exited)
	%CtrlInventoryGridMid.item_mouse_entered.connect(_on_item_mouse_entered)
	%CtrlInventoryGridMid.item_mouse_exited.connect(_on_item_mouse_exited)
	%CtrlInventoryGridMid2.item_mouse_entered.connect(_on_item_mouse_entered)
	%CtrlInventoryGridMid2.item_mouse_exited.connect(_on_item_mouse_exited)
	%CtrlInventoryGridRight.item_mouse_entered.connect(_on_item_mouse_entered)
	%CtrlInventoryGridRight.item_mouse_exited.connect(_on_item_mouse_exited)
	%BtnSortLeft.pressed.connect(_on_btn_sort.bind(%CtrlInventoryGridLeft))
	%BtnSortMid.pressed.connect(_on_btn_sort.bind(%CtrlInventoryGridMid))
	%BtnSortMid2.pressed.connect(_on_btn_sort.bind(%CtrlInventoryGridMid2))
	%BtnSortRight.pressed.connect(_on_btn_sort.bind(%CtrlInventoryGridRight))
	%BtnSplitLeft.pressed.connect(_on_btn_split.bind(%CtrlInventoryGridLeft))
	%BtnSplitMid.pressed.connect(_on_btn_split.bind(%CtrlInventoryGridMid))
	%BtnSplitMid2.pressed.connect(_on_btn_split.bind(%CtrlInventoryGridMid2))
	%BtnSplitRight.pressed.connect(_on_btn_split.bind(%CtrlInventoryGridRight))
	%BtnUnequip.pressed.connect(_on_btn_unequip)


func _on_item_mouse_entered(item: InventoryItem) -> void:
	%LblInfo.show()
	%LblInfo.text = item.get_title() + "\n" + item.get_description()


func _on_item_mouse_exited(_item: InventoryItem) -> void:
	%LblInfo.hide()


func _input(event: InputEvent) -> void:
	if !(event is InputEventMouseMotion):
		return

	%LblInfo.set_global_position(get_global_mouse_position() + info_offset)


func _on_btn_sort(ctrl_inventory) -> void:
	if !ctrl_inventory.inventory.get_constraint(GridConstraint).sort():
		print("Warning: GridConstraint.sort() returned false!")


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
	%InventoryRight.add_item(%CtrlItemSlot.item_slot.get_item())


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventoryItem


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print("jajco")
	#%CtrlInventoryGridLeft.inventory.remove_item(data)
	#%CtrlInventoryGridRight.inventory.remove_item(data)
	#%CtrlInventoryGridMid.inventory.remove_item(data)
	#%CtrlInventoryGridMid2.inventory.remove_item(data)
	# Add custom logic for handling the item drop here
