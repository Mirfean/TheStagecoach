extends Interactable_object
class_name Crafting_table

var craft_menu: crafting_menu

func Interact():
	super.Interact()
	start_craft()
	
func start_craft():
	Inventory_manager.open_crafting()
	print("craft")

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)

func _on_body_exited(body: Node2D) -> void:
	super._on_body_exited(body)
	
