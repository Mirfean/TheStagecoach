extends Control
class_name Achievement

@export var Title: String
@export_multiline var Description: String
@export var UnlockReq: String
@export var unlocked: bool

@export var sprite: Texture2D 
@onready var area_2d: Area2D = $Area2D
@onready var icon: TextureRect = $Icon
@onready var frame: TextureRect = $Frame

signal ShowInfo
signal HideInfo

func _ready() -> void:
	if sprite:
		icon.texture = sprite
		
func locking():
	if not unlocked:
		frame.modulate = Color(0.4, 0.4, 0.4)
		icon.modulate = Color(0.4, 0.4, 0.4)
	else:
		frame.modulate = Color(1, 1, 1)
		icon.modulate = Color(1, 1, 1)
		
func _on_area_2d_mouse_entered() -> void:
	if not unlocked:
		return
	ShowInfo.emit(self)
	
func _on_area_2d_mouse_exited() -> void:
	if not unlocked:
		return
	HideInfo.emit()
