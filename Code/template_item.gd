@tool
extends Node2D

@export var sprite_size: Vector2
@export var text: String

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _process(delta: float) -> void:
	sprite_2d.scale = sprite_size
	rich_text_label.text = text
