extends CharacterBody2D
class_name enemy

@export var stateMachine : StateMachine
@export var health : int
@export var vision_ray : RayCast2D

@onready var sight: Area2D = $Sight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
 
