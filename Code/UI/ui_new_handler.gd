extends Control
class_name ui_new_handler

@onready var safe_input: SafeInput = $SafeInput
@onready var close_safe_input: TextureButton = $CloseSafeInput

var current_lock: Node2D

func _ready() -> void:
	safe_input.sent_code.connect(receive_code)
	safe_input.visible = false
	close_safe_input.visible = false

func open_input(lock: Node2D):
	safe_input.visible = true
	close_safe_input.visible = true
	current_lock = lock 

func receive_code(code: String):
	if current_lock != null:
		var result = current_lock.verify_code(code)
		if result:
			current_lock.open_door()
			current_lock.disabled = true
			closing_safe_input()
			

func closing_safe_input():
	print("Seima")
	current_lock = null
	safe_input.text_edit.text = ""
	safe_input.visible = false
	close_safe_input.visible = false
