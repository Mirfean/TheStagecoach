extends State
class_name PlayerAim

@export var my_player : player
@export var aimSprite : Sprite2D
@export var aimer : Aimer
@export var weapon_holder : Node2D
@export var current_weapon : Node2D

var weaponType : String
var speed := 40
var interact := false

func Enter():
	my_player.speed = speed
	my_player.can_interact = interact
	current_weapon = weapon_holder.get_child(0)
	current_weapon.activate()
	weaponType = current_weapon.get("weapon_type")
	if weaponType == "2": #Range
		aimSprite.visible = true
		aimer.Lline.visible = true
		aimer.Rline.visible = true
		aimer.get_new_weapon(current_weapon.data)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func Exit():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	aimSprite.visible = false
	aimer.Lline.visible = false
	aimer.Rline.visible = false
	current_weapon.disactivate()
	
func InputState(event: InputEvent):
	if Input.is_action_just_released("Aim"):
		Transitioned.emit(self, "Default")
	elif weaponType == "2": #Range
		aimer.makeAim()
		aimer.rotate_weapon(current_weapon)
		if Input.is_action_just_pressed("Attack") and current_weapon.shot_available:
			var angle = aimer.get_random_angle()
			my_player.add_child(current_weapon.attack_range(angle))
	elif weaponType == "1": #MELEE
		aimer.rotate_weapon(current_weapon)
		if Input.is_action_just_pressed("Attack"):
			aimer.attack_melee(current_weapon)

func PhysicsUpdate(_delta : float):
	aimer.setAngle()
	if weaponType == "2":
		aimer.drewLines()
		
