extends AwarenessState
class_name EnemySearch

@export var waiting_time : float

var last_seen : Vector2
var wait_counter : float

func Enter():
	if not player_char:
		player_char = get_tree().get_first_node_in_group("player")
	nav_agent.target_position = player_char.position
	last_seen = player_char.position
	wait_counter = waiting_time
	timer.start(1)

func Exit():
	print("papa")
	#nav_agent.target_position = enemy_character.position

func PhysicsUpdate(delta : float):
	super.PhysicsUpdate(delta)
	if nav_agent.is_navigation_finished():
		wait_counter -= delta
		if wait_counter < 0:
			Transitioned.emit(self, "Idle")
	else:
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - enemy_character.global_position).normalized()
		enemy_character.velocity = direction * move_speed
#Jeśli nie, to wróć do Idle albo najpierw do swojego default miejsca


func _on_timer_timeout() -> void:
	if not nav_agent.is_navigation_finished():
		nav_agent.target_position = last_seen
		timer.start(1)
