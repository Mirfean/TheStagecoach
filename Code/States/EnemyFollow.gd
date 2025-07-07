extends AwarenessState
class_name EnemyFollow

@export var attack_distance : float
@export var distance_traveled: float
@export var reset_time : float

var last_check_point : Vector2 #Used for compare current position to unstuck potencial issues 

func Enter():
	#print("Follow")
	#Wygląda jakby w kółko spamowało Follow i enemy attack
	if not player_char:
		player_char = get_tree().get_first_node_in_group("player")
	nav_agent.target_position = player_char.position
	#print(enemy_character.position, nav_agent.target_position)
	timer.wait_time = reset_time
	timer.start()
	
	
func Exit():
	timer.stop()
	
#func PhysicsUpdate(delta: float):
	#super.PhysicsUpdate(delta)
	#if vision_ray.get_collider() != null:
		#print("Nie widzę :<")
	#var distance = vision_ray.target_position.length()
	#print_debug(distance)
	#if distance > vision_distance:
		#enemy_character.velocity = Vector2.ZERO
		#Transitioned.emit(self, "Idle")
	#elif distance > attack_distance:
		#enemy_character.velocity = vision_ray.target_position.normalized() * move_speed
	#elif distance < attack_distance:
		#Transitioned.emit(self, "Attack")

func PhysicsUpdate(delta: float):
	if Game_Manager.GAME_PAUSED:
		return
	super.PhysicsUpdate(delta)
	if nav_agent.distance_to_target() > vision_distance:
		enemy_character.velocity = Vector2.ZERO
		Transitioned.emit(self, "Idle")
	elif nav_agent.distance_to_target() > attack_distance:
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - enemy_character.global_position).normalized()
		enemy_character.velocity = direction * move_speed
	elif vision_ray.target_position.length() <= attack_distance or nav_agent.distance_to_target() <= attack_distance:
		if enemy_character.cooldown_timer <= 0:
			Transitioned.emit(self, "Attack")
	else:
		print("Ja nie rozumie")
#Set new player location after every X seconds
func _on_timer_timeout() -> void:
	#print("new path!")
	nav_agent.target_position = player_char.position
	timer.wait_time = reset_time
	timer.start()
