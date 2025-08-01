extends TestSuite

var inventory1: Inventory
var inventory2: Inventory
var item: InventoryItem

const TEST_PROTOSET = preload("res://tests/data/protoset_basic.json")

func init_suite() -> void:
    tests = [
        "test_size",
        "test_has_item",
        "test_add_remove",
        "test_create_and_add",
        "test_remove_item",
        "test_serialize",
        "test_serialize_json",
        "test_local_protoset",
    ]


func init_test() -> void:
    inventory1 = create_inventory(TEST_PROTOSET)
    inventory2 = create_inventory(TEST_PROTOSET)
    item = inventory1.create_and_add_item("minimal_item")


func cleanup_test() -> void:
    free_inventory(inventory1)
    free_inventory(inventory2)


func test_size() -> void:
    assert(inventory1.get_item_count() == 1)
    assert(inventory1.remove_item(item))
    assert(inventory1.get_item_count() == 0)


func test_add_remove() -> void:
    assert(inventory1.remove_item(item))
    assert(inventory1.get_item_count() == 0)
    assert(!inventory1.remove_item(item))

    assert(inventory1.add_item(item))
    assert(inventory1.get_item_count() == 1)
    assert(!inventory1.add_item(item))


func test_has_item() -> void:
    assert(inventory1.has_item_with_prototype_id("minimal_item"))
    assert(inventory1.has_item(item))
    assert(inventory1.remove_item(item))
    assert(!inventory1.has_item_with_prototype_id("minimal_item"))
    assert(!inventory1.has_item(item))


func test_create() -> void:
    var new_item = inventory2.create_item("minimal_item_2")
    assert(new_item)
    assert(!inventory2.has_item(new_item))


func test_create_and_add() -> void:
    var new_item = inventory2.create_and_add_item("minimal_item_2")
    assert(new_item)
    assert(inventory2.get_item_count() == 1)
    assert(inventory2.has_item(new_item))
    assert(inventory2.has_item_with_prototype_id("minimal_item_2"))


func test_remove_item() -> void:
    assert(inventory1.has_item(item))
    assert(inventory1.remove_item(item))
    assert(!inventory1.has_item(item))


func test_serialize() -> void:
    var inventory_data = inventory1.serialize()
    inventory1.reset()
    assert(inventory1.get_items().is_empty())
    assert(inventory1.deserialize(inventory_data))
    assert(inventory1.get_item_count() == 1)


func test_serialize_json() -> void:
    var inventory_data: Dictionary = inventory1.serialize()

    # To and from JSON serialization
    var json_string: String = JSON.stringify(inventory_data)
    var test_json_conv: JSON = JSON.new()
    assert(test_json_conv.parse(json_string) == OK)
    inventory_data = test_json_conv.data

    inventory1.reset()
    assert(inventory1.get_items().is_empty())
    assert(inventory1.deserialize(inventory_data))
    assert(inventory1.get_item_count() == 1)


func test_local_protoset() -> void:
    var inv := Inventory.new()
    var json := JSON.new()
    var file := FileAccess.open("res://tests/data/protoset_basic.json", FileAccess.READ)
    json.parse(file.get_as_text())
    inv.protoset = json
    assert(inv.create_and_add_item("minimal_item") != null)

    var inv_data = inv.serialize()
    inv.reset()
    inv.deserialize(inv_data)

    inv.queue_free()
