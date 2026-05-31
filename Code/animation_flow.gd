extends AnimationPlayer
class_name animation_flow

@export var id: String
@export var default_anim: String

func _ready() -> void:
	Game_Manager.add_to_registry(self)

func _exit_tree() -> void:
	Game_Manager.remove_from_registry(id)

func play_anim(anim_name: String = ""):
	if anim_name == "":
		self.play(default_anim)
	else:
		self.play(anim_name)
