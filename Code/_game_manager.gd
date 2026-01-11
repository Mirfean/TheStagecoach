extends Node
class_name GameManager

var player_char : player
var item_prefab : PackedScene = load("res://Scenes/pickable_item.tscn")

var flags = {}
var registry : Dictionary

var end_scene : PackedScene
var GAME_PAUSED := false

var current_loop : String

const info_offset: Vector2 = Vector2(50, 0)

func _ready() -> void:
	prep_start()

func prep_start():
	self.add_to_group("GameManager")
	player_char = get_tree().get_first_node_in_group("player")

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

func set_flag(name, value):
	flags[name] = value
	EventBus.emit_signal("flag_changed", name, value)

func has_flag(name):
	return flags.get(name, false)

func start_dialogue():
	if not player_char:
		player_char = get_tree().get_first_node_in_group("player")
	player_char.setIdleDirection()
	player_char.stateMachine.on_child_transition(player_char.stateMachine.currentState, "Dialogue")

func finish_game():
	get_tree().change_scene_to_file("res://Scenes/end_scene.tscn")

func set_group_to_registry(tag: String):
	registry.clear()
	for item in get_tree().get_nodes_in_group(tag):
		registry.set(item.id, item)
		
func add_to_registry(item :Node):
	if item.id == "":
		print_debug("Empty id for " + item.name + "!!!!")
		return
	if registry.has(item.id):
		print_debug("Duplicate id!!! " + item.id)
		return
	registry.set(item.id, item)

func get_from_registry(id: String):
	return registry.get(id)	
	
func endLoop(restart: bool = false):
	var loopStarter = get_tree().get_first_node_in_group("StarterLoop") as StartLoop
	loopStarter.reset_loop_audio.play()
	loopStarter.BlackingOff()
	await loopStarter.reset_loop_audio.finished

	reset_current_scene()
	
	
func reset_current_scene():
	registry.clear()
	get_tree().reload_current_scene()
	self.call_deferred("prep_start")
