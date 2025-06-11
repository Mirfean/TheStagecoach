extends Area2D
class_name Interactable_object

@export var default_material : Material
@export var outline_shader : ShaderMaterial

@export var active_sprite: Sprite2D
@export var collider : CollisionShape2D

@export var disabled : bool

func _ready() -> void:
	if active_sprite == null:
		for child in get_children():
			if child is Sprite2D:
				active_sprite = child
				break
	default_material = active_sprite.material
	
func pick_up():
	print("pick up")
	queue_free()

func on_highlight():
	print("Change to outline")
	active_sprite.material = outline_shader
	
func off_highlight():
	print("Change to without outline")
	active_sprite.material = default_material

func Interact():
	print("Interact xD")
	
func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and not disabled:
		body.set_new_closest(self)
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not disabled:
		body.remove_this_closest(self)
