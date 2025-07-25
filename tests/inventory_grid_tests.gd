extends TestSuite

var inventory_3x3: Inventory
var inventory_3x3_2: Inventory
var item_1x1: InventoryItem
var item_2x2: InventoryItem
var item_2x2_2: InventoryItem

const TEST_PROTOSET = preload("res://tests/data/protoset_grid.json")

func init_suite():
	tests = [
		"test_add_item",
		"test_add_item_at",
		"test_find_free_place",
		"test_change_size",
		"test_create_and_add_item_at",
		"test_get_item_at",
		"test_get_items_under",
		"test_move_item_to",
		"test_sort",
		"test_serialize",
		"test_serialize_json"
	]


func init_test():
	inventory_3x3 = create_inventory_grid(TEST_PROTOSET, Vector2i(3, 3))
	inventory_3x3_2 = create_inventory_grid(TEST_PROTOSET, Vector2i(3, 3))
	
	item_1x1 = create_item(TEST_PROTOSET, "item_1x1")
	item_2x2 = create_item(TEST_PROTOSET, "item_2x2")
	item_2x2_2 = create_item(TEST_PROTOSET, "item_2x2")


func cleanup_test() -> void:
	free_inventory(inventory_3x3)
	free_inventory(inventory_3x3_2)


func test_add_item() -> void:
	assert(inventory_3x3.add_item(item_1x1))
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_position(item_1x1) == Vector2i(0, 0))
	assert(inventory_3x3.add_item(item_2x2))
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_position(item_2x2) == Vector2i(0, 1))


func test_add_item_at() -> void:
	assert(!inventory_3x3.get_constraint(GridConstraint).add_item_at(item_1x1, Vector2i(4, 4)))
	assert(!inventory_3x3.get_constraint(GridConstraint).add_item_at(item_1x1, Vector2i(3, 3)))
	assert(inventory_3x3.get_constraint(GridConstraint).add_item_at(item_1x1, Vector2i(0, 0)))
	assert(!inventory_3x3.get_constraint(GridConstraint).add_item_at(item_2x2, Vector2i(0, 0)))
	assert(!inventory_3x3.get_constraint(GridConstraint).add_item_at(item_2x2, Vector2i(2, 2)))


func test_find_free_place() -> void:
	var grid_constraint: GridConstraint = inventory_3x3.get_constraint(GridConstraint)
	assert(grid_constraint.add_item_at(item_1x1, Vector2i(0, 0)))
	# Find place for an item that's already in the inventory
	var free_place := grid_constraint.find_free_place(item_1x1)
	assert(free_place.success)
	assert(free_place.position.x == 0)
	assert(free_place.position.y == 1)

	# Find place for an item that's not in the inventory
	free_place = grid_constraint.find_free_place(item_2x2)
	assert(free_place.success)
	assert(free_place.position.x == 0)
	assert(free_place.position.y == 1)


func test_change_size() -> void:
	assert(inventory_3x3.get_constraint(GridConstraint).add_item_at(item_1x1, Vector2i(0, 0)))
	assert(inventory_3x3.get_constraint(GridConstraint).add_item_at(item_2x2, Vector2i(1, 0)))
	inventory_3x3.get_constraint(GridConstraint).size.y = 2
	assert(inventory_3x3.get_constraint(GridConstraint).size.y == 2)
	inventory_3x3.get_constraint(GridConstraint).size.y = 3
	assert(inventory_3x3.get_constraint(GridConstraint).size.y == 3)
	inventory_3x3.get_constraint(GridConstraint).size.x = 2
	assert(inventory_3x3.get_constraint(GridConstraint).size.x == 3)


func test_create_and_add_item_at() -> void:
	var new_item = inventory_3x3.get_constraint(GridConstraint).create_and_add_item_at("item_1x1", Vector2i(1, 1))
	assert(new_item)
	assert(inventory_3x3.get_item_count() == 1)
	assert(inventory_3x3.has_item(new_item))
	assert(inventory_3x3.has_item_with_prototype_id("item_1x1"))
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_position(new_item) == Vector2i(1, 1))


func test_get_item_at() -> void:
	assert(inventory_3x3.get_constraint(GridConstraint).add_item_at(item_2x2, Vector2i(1, 1)))
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_at(Vector2i(0, 0)) == null)
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_at(Vector2i(1, 1)) == item_2x2)
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_at(Vector2i(2, 2)) == item_2x2)
	assert(inventory_3x3.get_constraint(GridConstraint).move_item_to(item_2x2, Vector2i(0, 0)))
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_at(Vector2i(2, 2)) == null)
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_at(Vector2i(0, 0)) == item_2x2)


func test_get_items_under() -> void:
	assert(inventory_3x3.add_item(item_1x1))
	assert(inventory_3x3.add_item(item_2x2))
	var items = inventory_3x3.get_constraint(GridConstraint).get_items_under(Rect2i(0, 0, 2, 2))
	assert(items.size() == 2)
	assert(item_1x1 in items)
	assert(item_2x2 in items)


func test_move_item_to() -> void:
	assert(inventory_3x3.add_item(item_1x1))

	# Move to the same location
	assert(inventory_3x3.get_constraint(GridConstraint).move_item_to(item_1x1, Vector2i.ZERO))
	assert(inventory_3x3.get_item_count() == 1)
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_position(item_1x1) == Vector2i.ZERO)
	
	# Move to a new location
	assert(inventory_3x3.get_constraint(GridConstraint).move_item_to(item_1x1, Vector2i.ONE * 2))
	assert(inventory_3x3.get_item_count() == 1)
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_position(item_1x1) == Vector2i.ONE * 2)

	# Move to an occupied location
	assert(inventory_3x3.add_item(item_2x2))
	assert(!inventory_3x3.get_constraint(GridConstraint).move_item_to(item_1x1, Vector2i.ZERO))
	assert(inventory_3x3.get_item_count() == 2)
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_position(item_1x1) == Vector2i.ONE * 2)


func test_sort() -> void:
	assert(inventory_3x3.get_constraint(GridConstraint).add_item_at(item_1x1, Vector2i(1, 0)))
	assert(inventory_3x3.get_constraint(GridConstraint).add_item_at(item_2x2, Vector2i(1, 1)))
	assert(inventory_3x3.get_constraint(GridConstraint).sort())
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_at(Vector2i(0, 0)) == item_2x2)
	assert(inventory_3x3.get_constraint(GridConstraint).get_item_at(Vector2i(0, 2)) == item_1x1)


func test_serialize():
	var grid_constraint: GridConstraint = inventory_3x3.get_constraint(GridConstraint)
	assert(grid_constraint.add_item_at(item_1x1, Vector2i.ZERO))
	assert(grid_constraint.add_item_at(item_2x2, Vector2i.ONE))
	var inventory_data = inventory_3x3.serialize()

	inventory_3x3.reset()
	assert(inventory_3x3.get_items().is_empty())

	assert(inventory_3x3.deserialize(inventory_data))
	grid_constraint = inventory_3x3.get_constraint(GridConstraint)
	assert(inventory_3x3.get_item_count() == 2)
	assert(grid_constraint.size.x == 3)
	assert(grid_constraint.size.y == 3)
	assert(grid_constraint.get_item_position(inventory_3x3.get_items()[0]) == Vector2i.ZERO)
	assert(grid_constraint.get_item_position(inventory_3x3.get_items()[1]) == Vector2i.ONE)
	

func test_serialize_json():
	var grid_constraint: GridConstraint = inventory_3x3.get_constraint(GridConstraint)
	assert(grid_constraint.add_item_at(item_1x1, Vector2i.ZERO))
	assert(grid_constraint.add_item_at(item_2x2, Vector2i.ONE))
	var inventory_data = inventory_3x3.serialize()

	# To and from JSON serialization
	var json_string: String = JSON.stringify(inventory_data)
	var test_json_conv: JSON = JSON.new()
	assert(test_json_conv.parse(json_string) == OK)
	inventory_data = test_json_conv.data

	inventory_3x3.reset()
	assert(inventory_3x3.get_items().is_empty())

	assert(inventory_3x3.deserialize(inventory_data))
	grid_constraint = inventory_3x3.get_constraint(GridConstraint)
	assert(inventory_3x3.get_item_count() == 2)
	assert(grid_constraint.size.x == 3)
	assert(grid_constraint.size.y == 3)
	assert(grid_constraint.get_item_position(inventory_3x3.get_items()[0]) == Vector2i.ZERO)
	assert(grid_constraint.get_item_position(inventory_3x3.get_items()[1]) == Vector2i.ONE)
