extends AwarenessState
class_name enemy_characterIdle

var moveDirection : Vector2
var wanderTime : float

func randomizeWander():
	moveDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wanderTime = randf_range(1, 3)

func Enter():
	print("idle")
	randomizeWander()
	if not player_char:
		player_char = get_tree().get_first_node_in_group("player")
	
func Update(delta: float):
	if wanderTime > 0:
		wanderTime -= delta
	else: 
		randomizeWander()
	
func PhysicsUpdate(delta: float):
	super.PhysicsUpdate(delta)
	if enemy_character:
		enemy_character.velocity = moveDirection * move_speed


#func PhysicsUpdate(delta: float):
	#super.PhysicsUpdate(delta)
	#if !nav_agent.is_target_reached():
		#var direction = enemy_character.to_local(nav_agent.get_next_path_position().normalized())
		#enemy_character.velocity = direction * move_speed * delta


func _on_timer_timeout() -> void:
	pass # Replace with function body.
