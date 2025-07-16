extends Node2D

@onready var texture_button: TextureButton = $TextureButton

func _on_texture_button_pressed() -> void:
	get_tree().quit()
