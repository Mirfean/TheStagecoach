extends Area2D
class_name weapon_stats

@onready var firerate_timer: Timer = $Firerate

@export var data : _Weapon_
@export var sprite : Node2D
@export var animation : AnimationPlayer
@export var sound_attack : AudioStreamPlayer2D

var ID : int
var weapon_type : String
var damage : int
var during_attack : bool
var rotation_attack : float

func _ready() -> void:
	ID = data.id
	weapon_type = str(data.weapon_type)
	damage = data.damage
	disactivate()
	
func attack():
	print_debug("undefined attack")
	
func activate():
	print("Odpalam broń")
	sprite.visible = true
	
func disactivate():
	print("Wyłączam broń")
	sprite.visible = false
		
func _process(delta: float) -> void:
	if not during_attack:
		return
	
