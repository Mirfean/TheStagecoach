extends AudioStreamPlayer2D
class_name sound_effect

@export var id: String
@export var time: float
@onready var timer: Timer = $Timer

func _ready() -> void:
	Game_Manager.add_to_registry(self)

func play_sound():
	timer.wait_time = time
	timer.one_shot = true
	timer.start(time)

func _on_timer_timeout() -> void:
	self.play()
