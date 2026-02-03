extends weapon_stats
class_name weapon_melee

@export var collider : CollisionShape2D

func _ready() -> void:
	super._ready()
	if animation:
		animation.animation_finished.connect(reset)

func attack(): #now only for melee
	rotation_attack = self.rotation
	if collider:
		active_collider(true)
		animation.play("attack")
		sound_attack.play()
		
	
func reset(anim_name: String):
	if anim_name == "attack":
		if animation.has_animation("return"):
			animation.play("return")
		else:
			animation.play("RESET")
	else:
		animation.play("RESET")
	active_collider(false)

func _on_body_entered(body : Node2D):
	if body.is_in_group("enemy"):
		print(body.name, " attacked")
		body.getDamage(damage)
		
func activate():
	super.activate()
	if collider:
		collider.disabled = false

func disactivate():
	super.disactivate()
	if collider:
		collider.disabled = true

func active_collider(x : bool):
	collider.disabled = !x
