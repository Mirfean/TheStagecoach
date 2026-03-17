extends Area2D
class_name area_trigger

@export var id: String
@export var player_trigger: bool = true
@export var enemy_trigger: bool = false
@export var DestroyAfter: bool = false

func _on_body_entered(body: Node2D) -> void:
	EventBus.emit_signal("area_entered", id)
	print("Stepped on " + id)
	
func _on_body_exited(body: Node2D) -> void:
	if DestroyAfter:
		queue_free()
