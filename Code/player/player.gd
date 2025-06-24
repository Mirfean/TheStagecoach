extends CharacterBody2D
class_name player

enum PlayerState {
	Default, #Chłopek może sobie chodzić, biegać i przeprowadzać interakcje z przedmiotami
	Locked, #Coś jak cutscenki itd, że nie może się ruszać i klikać
	Aim #celowanie giwerą :essa:
}

enum LookDirection {
	Up,
	Down,
	Left,
	Right
}

@onready var playerSprite: AnimatedSprite2D = $CharacterAnimSprite
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var aimer: Sprite2D = $Aim/Aimer

@export var inventory : user_inventory
@export var stateMachine : StateMachine
@export var weapons : Array[_Weapon_]
@export var weapon_index : int
@export var weapon_data : _Weapon_
@export var WeaponHolder : Node2D

var character_direction : Vector2
var weapon_instance : Node2D

var closest_interaction : Node2D

#PlayerStats
var playerState := PlayerState.Default
@export var lookDirection := LookDirection.Down
var can_interact := true
var speed := 80
var dead := false
var health := 50



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory_manager.player_char = self
	inventory = get_tree().get_first_node_in_group("Inventory")
	aimer.visible = false
	set_weapon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if stateMachine.currentState.name == "Default":
		if event.is_action_pressed("ChangeWeapon"):
			set_weapon((weapon_index+1)%weapons.size())
		if event.is_action_pressed("Interaction"):
			if closest_interaction != null:
				closest_interaction.Interact()
		if event.is_action_pressed("Inventory"):
			if stateMachine.currentState.name == "Inventory":
				Inventory_manager.closeInvUI()
			else:
				inventory.activate()
	if event.is_action_pressed("Close") and stateMachine.currentState.name == "Inventory":
		Inventory_manager.closeInvUI()
	#if event.is_action_pressed("TestButton") and stateMachine.currentState.name == "Default":
		#DialogueManager.show_dialogue_balloon(load("res://Scenes/balloon.tscn"), "start")

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if stateMachine.currentState.name == "Default" or stateMachine.currentState.name == "Aim":
		Movement()

func Movement():
	character_direction.x = Input.get_axis("moveLeft", "moveRight")
	character_direction.y = Input.get_axis("moveUp", "moveDown")
	setLookingDirection()
	#Flip Sprite
	if character_direction.y < 0:
		playerSprite.flip_h = false
		playerSprite.play("MoveUp")
	elif character_direction.y > 0: 
		playerSprite.flip_h = false
		playerSprite.play("MoveDown")
	elif character_direction.x > 0: 
		playerSprite.flip_h = false
		playerSprite.play("MoveHorizontal")
	elif character_direction.x < 0:
		playerSprite.flip_h = true
		playerSprite.play("MoveHorizontal")
	
	if character_direction:
		if character_direction.x != 0 and character_direction.y != 0:
			character_direction = character_direction * 0.7
		velocity = character_direction * speed 
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		#Set all 3 Idles later
		match lookDirection:
			LookDirection.Up:
				playerSprite.play("Idle-back")
			LookDirection.Down:
				playerSprite.play("Idle-front")
			LookDirection.Left:
				playerSprite.play("Idle-horizontal")
				playerSprite.flip_h = true
			LookDirection.Right:
				playerSprite.play("Idle-horizontal")
				playerSprite.flip_h = false
		
		
		
	move_and_slide()


func setLookingDirection():
	var direction_vector = self.global_position - get_global_mouse_position()
	var dead_zone_radius = 20
	if direction_vector.length() < dead_zone_radius:
		print("In dead zone")
		return
	var angle = rad_to_deg(direction_vector.angle())
	if angle >= -45 and angle < 45:
		lookDirection = LookDirection.Left
	elif angle >= 45 and angle < 135:
		lookDirection = LookDirection.Up
	elif angle >= 135 or angle < -135:
		lookDirection = LookDirection.Right
	elif angle >= -135 and angle < -45:
		lookDirection = LookDirection.Down



func set_weapon(weapon_id : int = 0):
	if weapon_instance:
		weapon_instance.queue_free()
		weapon_instance = null
	weapon_data = weapons[weapon_id]
	var new_weapon = load(weapon_data.weapon)
	weapon_instance = new_weapon.instantiate()
	WeaponHolder.add_child(weapon_instance)
	weapon_instance.position = Vector2.ZERO
	weapon_index = weapon_id
	for x in weapons:
		print(x.nameW)
	
func set_new_closest(object : Interactable_object):
	print("Siema")
	if closest_interaction != null:
		closest_interaction.off_highlight()
	closest_interaction = object
	closest_interaction.on_highlight()
	
func remove_this_closest(object : Interactable_object):
	print("Papa")
	if closest_interaction == object:
		closest_interaction.off_highlight()
		closest_interaction = null
		
func open_inventory_state():
	print("Inventory")
	if stateMachine.currentState.name == "Default":
		stateMachine.on_child_transition(stateMachine.currentState, "Inventory")
	
func close_inventory_state():
	print("Close Inventory")
	if stateMachine.currentState.name == "Inventory":
		stateMachine.on_child_transition(stateMachine.currentState, "Default")
	
func getDamage(damage: int):
	if dead:
		return
	health -= damage
	#Animacja obrażeń
	print("My health is ", health)
	if health <= 0:
		die()
	
func die():
	dead = true
	playerSprite.play("Dying")
	
	
