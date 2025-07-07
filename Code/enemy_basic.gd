extends enemy
class_name enemy_basic

@export var vision_distance : float
@export var attack_cooldown : float
@export var state_text : Label

var cooldown_timer : float

func _process(delta: float) -> void:
	if Game_Manager.GAME_PAUSED:
		return
	#DEBUG
	queue_redraw()
	#DEBUG
	if cooldown_timer > 0:
		cooldown_timer -= delta

func _physics_process(delta: float) -> void:
	if Game_Manager.GAME_PAUSED:
		return
	var current_vision = vision_distance
	state_text.text = stateMachine.currentState.name
	if stateMachine.currentState.player_char.stealth:
		current_vision = current_vision / 2
	if vision_ray.target_position.length() < current_vision and not vision_ray.is_colliding() and stateMachine.currentState.name != "Follow":
		stateMachine.on_child_transition(stateMachine.currentState, "Follow")
	elif (vision_ray.is_colliding() or vision_ray.target_position.length() > current_vision) and stateMachine.currentState.name == "Follow":
		stateMachine.on_child_transition(stateMachine.currentState, "Search")
	move_and_slide()

func _draw() -> void:
	var rayColor = Color.WHITE
	match stateMachine.currentState.name:
		"Idle":
			rayColor = Color.GRAY
		"Follow":
			rayColor = Color.YELLOW_GREEN
		"Attack":
			rayColor = Color.BLUE
		"Search":
			rayColor = Color.PALE_TURQUOISE
	if vision_ray.is_colliding():
		rayColor = Color.RED
	#draw_line(vision_ray.position, vision_ray.target_position, rayColor, 1.0)

func getDamage(damage : int):
	print_debug("dealt ", damage, " remaining hp:", health)
	animation_player.play("get_hit")
	health -= damage
	if health <= 0:
		queue_free()
		
func is_collider_low() -> bool:
	print_debug("Siemano")
	return true
	#TODO for chairs, tables etc. items that are low and enemy can see through them
	#vision_ray.get_collider()
	
func cooldown():
	cooldown_timer = attack_cooldown

#func _on_sight_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#print("Changing to follow")
		#stateMachine.on_child_transition(stateMachine.currentState, "Follow")
#
#func _on_sight_body_exited(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#print("Changing to idle")
		#stateMachine.on_child_transition(stateMachine.currentState, "Idle")

func start_attack():
	print("Changing to attack")
	stateMachine.on_child_transition(stateMachine.currentState, "Attack")
	
