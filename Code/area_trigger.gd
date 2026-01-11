extends Area2D
class_name area_trigger

@export var id: String
@export var player_trigger: bool = true
@export var enemy_trigger: bool = false


func _on_body_entered(body: Node2D) -> void:
	EventBus.emit_signal("area_entered", id)

func _on_body_exited(body: Node2D) -> void:
	queue_free()
