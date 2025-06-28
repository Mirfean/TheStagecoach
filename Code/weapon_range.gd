extends weapon_stats
class_name weapon_range

@export var shoot_point : Node2D
@export var bullet : PackedScene
@export var sound_reload : AudioStreamPlayer2D
@export var sound_empty : AudioStreamPlayer2D
@export var clip_size : int


var bullet_speed = 500
var shot_available = true

func _ready() -> void:
	super._ready()
	firerate_timer.wait_time = data.fireRate

func attack_range(angle : float) -> Node2D:
	print("Siema")
	if clip_size <= 0:
		sound_empty.play()
		return null
	var bullet_instance = bullet.instantiate()
	if bullet_instance is Bullet:
		bullet_instance.damage = damage
		print("set dmg ", bullet_instance.damage)
	bullet_instance.position = Vector2.ZERO + get_parent().position
	bullet_instance.rotation = angle
	bullet_instance.apply_impulse(Vector2(cos(angle), sin(angle)).normalized() * bullet_speed, Vector2.ZERO)
	shot_available = false
	firerate_timer.start()
	clip_size -= 1
	sound_attack.play()
	return bullet_instance
	

func _on_firerate_timeout() -> void:
	shot_available = true
