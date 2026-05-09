extends Control
class_name start_menu

@onready var start_game: TextureButton = $StartGame
@onready var options: TextureButton = $Options
@onready var exit_game: TextureButton = $ExitGame
@onready var achievement: TextureButton = $Achievement


func _on_start_game_pressed_Start() -> void:
	#System to choose level to run
	get_tree().change_scene_to_file("res://Scenes/apartment_in_dream.tscn") 


func _on_options_pressed_options() -> void:
	pass # Replace with function body.


func _on_exit_game_pressed_exit() -> void:
	get_tree().quit()


func _on_achievement_pressed_achiev() -> void:
	pass # Replace with function body.
