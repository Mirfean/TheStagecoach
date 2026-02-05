extends Area2D
class_name checkpointTile

@export var add_or_remove: bool = true
@export var myTilePart: TilePart 
@export var tileParts: Array[PackedScene]
@export var marker: Marker2D

signal addTilePart
signal removeFromMarker

func _ready() -> void:
	myTilePart = get_parent() as TilePart

func _on_body_entered(body: Node2D) -> void:
	print_debug("Triggered! " + self.name + " " + get_parent().name)
	if add_or_remove:
		if tileParts.size() == 0:
			print_debug("No tilePart to add! Change to remove or add tilePart")
			return
		addTilePart.emit(marker, tileParts[randf_range(0, tileParts.size() - 1)])
	else:
		removeFromMarker.emit(marker)


func _on_body_exited(body: Node2D) -> void:
	queue_free()
