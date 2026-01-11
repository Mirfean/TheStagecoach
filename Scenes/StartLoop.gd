extends Node
class_name StartLoop

var id = "StartLoop"
@export var loop: String 

@export var player_char: player
@export var black_screen: ColorRect
@export var starting_dialogue: Dialoguer

@export var reset_loop_audio: AudioStreamPlayer2D

@export var off : bool

func _ready() -> void:
	call_deferred("setup_loop")
	Game_Manager.add_to_registry(self)
	
func BlackScreenOnOff():
	black_screen.visible = not black_screen.visible
	
func BlackingOff():
	black_screen.visible = true
	black_screen.color.a = 0
	var tween = create_tween()
	# Zmienia alpha (modulate:a) do 1.0 w czasie 2 sekund
	tween.tween_property(black_screen, "color:a", 1.0, 3.0)
	
	
func setup_loop():
	if off:
		return
	var LOOP = loop.to_lower().replace(" ", "")
	match LOOP:
		"loop1": 
			black_screen.visible = true
			player_char.playerSprite.play("lying")
			starting_dialogue.Interact()
			Game_Manager.get_from_registry("door_biuro0p").locked = true
