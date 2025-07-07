extends AwarenessState
class_name enemy_characterIdle

var wander_target_position: Vector2
var move_direction : Vector2
var wander_time : float

func randomizeWander():
	wander_target_position = enemy_character.global_position + Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 80
	nav_agent.set_target_position(wander_target_position)
	wander_time = randf_range(1, 3) # Czas po którym losuje nowy cel
	print("NEW RANDOM")

func Enter():
	print("idle")
	randomizeWander()
	if not player_char:
		player_char = get_tree().get_first_node_in_group("player")
	
func Update(delta: float):
	if Game_Manager.GAME_PAUSED:
		return
	if wander_time < 0:
		randomizeWander()
	else: 
		wander_time -= delta
	
func PhysicsUpdate(delta: float):
	if Game_Manager.GAME_PAUSED:
		return
	super.PhysicsUpdate(delta)
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - enemy_character.global_position).normalized()
	enemy_character.velocity = direction * move_speed
	
	#if nav_agent.is_target_reachable() == false and enemy_character.velocity.length_squared() < 1:
		#randomizeWander()
	
	

#func PhysicsUpdate(delta: float):
	#super.PhysicsUpdate(delta)
	#if !nav_agent.is_target_reached():
		#var direction = enemy_character.to_local(nav_agent.get_next_path_position().normalized())
		#enemy_character.velocity = direction * move_speed * delta


func _on_timer_timeout() -> void:
	pass # Replace with function body.
