extends TextureProgressBar
class_name StaminaBar

@export var regen_per_second : float
@export var running_exhaust_per_second : float

var is_running : bool
var is_exhausted : bool
var positive_container : float
var negative_container : float

signal rested
signal exhausted

func _process(delta: float) -> void:
	if Game_Manager.GAME_PAUSED:
		return
	if not is_running and value < max_value:
		var regen = regen_per_second * delta
		if is_exhausted:
			regen *= 0.7
		positive_container += regen	
		if positive_container > 1.0:
			positive_container -= 1.0
			value = clamp(value + 1, min_value, max_value)
		if value == max_value:
			rested.emit()
			rested_bar()
	elif value > min_value and is_running and not is_exhausted:
		var decrease = running_exhaust_per_second * delta
		negative_container += decrease
		if negative_container > 1:
			negative_container -= 1
			value = clamp(value - 1, min_value, max_value)
	elif value == min_value:
		exhausted.emit()
		exhaust_bar()
		
func exhaust_bar():
	tint_progress = Color.DARK_RED
	is_running = false
	is_exhausted = true

func rested_bar():
	tint_progress = Color.WHITE
	is_exhausted = false
