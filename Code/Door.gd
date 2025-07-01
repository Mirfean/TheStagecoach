extends StaticBody2D
class_name Door

@export var sprite_close : Texture2D
@export var sprite_open : Texture2D
@export var horizontal : bool

@onready var door_visual: Sprite2D = $InteractionArea/DoorVisual
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var vertical_occluder: LightOccluder2D = $VerticalOccluder
@onready var horizontal_occluder: LightOccluder2D = $HorizontalOccluder

var opened : bool

func _ready() -> void:
	if horizontal:
		vertical_occluder.visible = false
	else:
		horizontal_occluder.visible = false

func open_door():
	if not opened:
		opened = true
		collision_shape_2d.disabled = true
		door_visual.texture = sprite_open
		horizontal_occluder.visible = false
		vertical_occluder.visible = false

func close_door():
	if opened:
		opened = false
		collision_shape_2d.disabled = false
		door_visual.texture = sprite_close
		if horizontal:
			horizontal_occluder.visible = true
		else:
			vertical_occluder.visible = true
