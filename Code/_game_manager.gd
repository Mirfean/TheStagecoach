extends Node
class_name GameManager

var player_char : player
var item_prefab : PackedScene = load("res://Scenes/pickable_item.tscn")


func _ready() -> void:
	player_char = get_tree().get_first_node_in_group("player")
	Inventory_manager.game_manager = self

func spawn_item_on_ground(place : Vector2):
	print("Spawn item")
	# Wziąć InventoryItem
	# Stworzyć item z PackedScene
	# Nadać mu ten InventoryItem
	# Sprawn pod nogami postaci
	
func attach_item_from_ground():
	print("attach item to inventory")
	# Przyjąć item 
	# Stworzyć item i dodać do user_inventory
	# Usunięcie itemu z podłogi jeśli item się mieści gdzieś
