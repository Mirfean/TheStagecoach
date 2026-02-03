extends RigidBody2D
class_name Bullet

@export var lifespan : float
@export var damage : int

var hitted : bool
var penetration : bool

func _ready():
	print("Tworzony pocisk")
	# Dodaj węzeł Timer dynamicznie
	var lifespan_timer = Timer.new()
	add_child(lifespan_timer)

	# Ustaw czas życia (w sekundach)
	lifespan_timer.wait_time = 5.0

	# Ustaw na jednorazowy
	lifespan_timer.one_shot = true

	# Połącz sygnał timeout z funkcją _on_lifespan_timeout
	lifespan_timer.timeout.connect(_on_lifespan_timeout)

	# Uruchom timer
	lifespan_timer.start()

func _on_lifespan_timeout():
	queue_free()
	
func bullet_hit():
	if not penetration:
		queue_free()
	hitted = true

func _on_body_entered(body: Node) -> void:
	print("bullet hit", body.get_parent().name)
	if body.is_in_group("enemy"):
		self.sleeping = true
		body.getDamage(damage)
		queue_free()
