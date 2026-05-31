extends AudioStreamPlayer2D
class_name sound_effect

@export var id: String
@export var time: float
@onready var timer: Timer = $Timer

func _ready() -> void:
	print_debug("register " + id)
	Game_Manager.add_to_registry(self)
	
func _exit_tree() -> void:
	Game_Manager.remove_from_registry(id)

func play_sound():
	if time > 0:
		timer.wait_time = time
		timer.one_shot = true
		timer.start(time)
	else:
		self.play()

func _on_timer_timeout() -> void:
	self.play()
