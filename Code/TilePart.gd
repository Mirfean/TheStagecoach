extends TileMapLayer
class_name TilePart

@export var ID: int
@export var markers: Array[Marker2D]
@export var checkpoints: Array[checkpointTile]

var marker0: Marker2D
var activeConnections: Dictionary [Marker2D, TilePart]
var tileHandler: TileHandler

func _ready() -> void:
	for marker in find_children("Marker*"):
		markers.append(marker)
		if marker.position == Vector2.ZERO:
			marker0 = marker
		
	for check in find_children("Checkpoint*"):
		checkpoints.append(check)
	for check in checkpoints:
		if check.add_or_remove:
			check.addTilePart.connect(AddTilePart)
		else:
			check.removeFromMarker.connect(RemoveTilePart)
	
func AddTilePart(marker: Marker2D, scene: PackedScene):
	var newTilePart: TilePart = await spawn_tile_part(scene, marker.global_position)
	activeConnections.set(marker, newTilePart)
	newTilePart.activeConnections.set(newTilePart.marker0, self)

func RemoveTilePart(marker: Marker2D):
	if activeConnections.has(marker):
		var tilePart: TilePart = activeConnections[marker]
		if tilePart != null:
			activeConnections.erase(marker)
			remove_tile_part(tilePart)

func spawn_tile_part(scene: PackedScene, position: Vector2) -> TilePart:
	var tile_part_instance: TilePart = scene.instantiate()
	get_parent().call_deferred("add_child", tile_part_instance)
	await tile_part_instance.ready
	tile_part_instance.global_position = position
	return tile_part_instance
	
func remove_tile_part(tilePart: TilePart):
	#Cleaning
	tilePart.queue_free()
