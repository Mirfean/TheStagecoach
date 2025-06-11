extends StaticBody2D
class_name Door

@export var sprite_close : Texture2D
@export var sprite_open : Texture2D

@onready var door_visual: Sprite2D = $InteractionArea/DoorVisual
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var opened : bool

func open_door():
	if not opened:
		opened = true
		collision_shape_2d.disabled = true
		door_visual.texture = sprite_open
	

func close_door():
	if opened:
		opened = false
		collision_shape_2d.disabled = false
		door_visual.texture = sprite_close
