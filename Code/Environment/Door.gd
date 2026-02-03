extends StaticBody2D
class_name Door

@export var id: String

@export var sprite_close : Texture2D
@export var sprite_open : Texture2D
@export var horizontal : bool
@export var reversed: bool

@onready var door_visual: Sprite2D = $InteractionArea/DoorVisual
@onready var current_shape2D: CollisionShape2D
@onready var vertival_collision: CollisionShape2D = $VertivalCollision
@onready var horizontal_collision: CollisionShape2D = $HorizontalCollision
@onready var vertical_occluder: LightOccluder2D = $VerticalOccluder
@onready var horizontal_occluder: LightOccluder2D = $HorizontalOccluder

var opened : bool

var locked : bool

func _ready() -> void:
	door_visual.texture = sprite_close
	if horizontal:
		vertical_occluder.visible = false
		vertival_collision.disabled = true
		current_shape2D = horizontal_collision
	else:
		horizontal_occluder.visible = false
		horizontal_collision.disabled = true
		current_shape2D = vertival_collision
	if reversed:
		scale.x = -scale.x
	
	Game_Manager.add_to_registry(self)

func open_door():
	if locked:
		print_debug("Add door locked sounds")
		return
	
	if not opened:
		EventBus.emit_signal("door_opened", id)
		
		opened = true
		current_shape2D.disabled = true
		door_visual.texture = sprite_open
		horizontal_occluder.visible = false
		vertical_occluder.visible = false

func close_door():
	if opened:
		opened = false
		current_shape2D.disabled = false
		door_visual.texture = sprite_close
		if horizontal:
			horizontal_occluder.visible = true
		else:
			vertical_occluder.visible = true
