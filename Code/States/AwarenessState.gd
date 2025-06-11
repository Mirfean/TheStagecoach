extends State
class_name AwarenessState

@export var enemy_character: CharacterBody2D
@export var move_speed := 20.0
@export var vision_ray : RayCast2D
@export var vision_distance : float
@export var goal: Node = null #For pathfinding
@export var nav_agent : NavigationAgent2D
@export var timer : Timer
@export var player_char: CharacterBody2D

func PhysicsUpdate(_delta : float):
	vision_ray.target_position = player_char.global_position - enemy_character.global_position
