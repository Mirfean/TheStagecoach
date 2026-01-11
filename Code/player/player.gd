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
@export var staminaBar: StaminaBar
@export var stateMachine : StateMachine
@export var weapons : Array[_Weapon_]
@export var weapon_index : int
@export var weapon_data : _Weapon_
@export var WeaponHolder : Node2D
@export var vision : player_vision
@export var sound_walking : AudioStreamPlayer2D
@export var EndLoopTimer: Timer

var character_direction : Vector2
var weapon_instance : Node2D
var stealth := false
var exhausted := false
var running := false
var closest_interaction : Node2D

#PlayerStats
var playerState := PlayerState.Default
@export var lookDirection := LookDirection.Down
var can_interact := true
var speed := 30
var sideway_speed := 0.7
var backward_speed := 0.5
var dead := false
var health := 50



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory_manager.player_char = self
	inventory = get_tree().get_first_node_in_group("Inventory")
	staminaBar = get_tree().get_first_node_in_group("StaminaBar")
	aimer.visible = false
	set_weapon()
	
func _input(event: InputEvent) -> void:
	if dead:
		return
	if stateMachine.currentState.name == "Default":
		if event.is_action_pressed("Stealth") and not stealth:
			make_stealth(true)
		elif event.is_action_pressed("Run") and not running and not staminaBar.is_exhausted:
			start_running()
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
	if event.is_action_released("Run"):
		stop_running()
	if event.is_action_released("Stealth"):
		make_stealth(false)
		
func _physics_process(_delta: float) -> void:
	#print(stateMachine.currentState.name)
	if dead:
		return
	
	if stateMachine.currentState.name == "Default" or stateMachine.currentState.name == "Aim":
		Movement()
		if vision != null:
			vision.setAngle()

func Movement():
	if playerSprite.animation == "lying":
		return
	character_direction.x = Input.get_axis("moveLeft", "moveRight")
	character_direction.y = Input.get_axis("moveUp", "moveDown")
	setLookingDirection()

	if character_direction:
		match lookDirection:
			LookDirection.Up:
				playerSprite.flip_h = false
				playerSprite.play("MoveUp")
				character_direction.x = character_direction.x * sideway_speed
				if character_direction.y > 0:
					character_direction.y = character_direction.y * backward_speed
			LookDirection.Down:
				playerSprite.flip_h = false
				playerSprite.play("MoveDown")
				character_direction.x = character_direction.x * sideway_speed
				if character_direction.y < 0:
					character_direction.y = character_direction.y * backward_speed
			LookDirection.Left:
				playerSprite.play("MoveLeft")
				character_direction.y = character_direction.y * sideway_speed
				if character_direction.x > 0:
					character_direction.x = character_direction.x * backward_speed
			LookDirection.Right:
				playerSprite.play("MoveRight")
				character_direction.y = character_direction.y * sideway_speed
				if character_direction.x < 0:
					character_direction.x = character_direction.x * backward_speed
		if character_direction.x != 0 and character_direction.y != 0:
			character_direction = character_direction * 0.7
		if stealth:
			character_direction = character_direction * 0.5
		elif running:
			character_direction = character_direction * 1.5
		velocity = character_direction * speed 
		if not sound_walking.playing:
			sound_walking.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		setIdleDirection()
		
		if sound_walking.playing:
			sound_walking.stop()
	move_and_slide()

func setIdleDirection():
	match lookDirection:
			LookDirection.Up:
				playerSprite.play("Idle-back")
			LookDirection.Down:
				playerSprite.play("Idle-front")
			LookDirection.Left:
				playerSprite.play("Idle-left")
			LookDirection.Right:
				playerSprite.play("Idle-right")

func setLookingDirection():
	var direction_vector = self.global_position - get_global_mouse_position()
	var dead_zone_radius = 20
	if direction_vector.length() < dead_zone_radius:
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
	if closest_interaction != null:
		closest_interaction.off_highlight()
	closest_interaction = object
	closest_interaction.on_highlight()
	
func remove_this_closest(object : Interactable_object):
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

func start_running():
	print("Run start")
	running = true
	staminaBar.is_running = true
	staminaBar.exhausted.connect(stop_running)
	
func stop_running():
	print("Run stop")
	running = false
	staminaBar.is_running = false
	if staminaBar.exhausted.has_connections():
		staminaBar.exhausted.disconnect(stop_running)

func move_me(x: float, y: float):
	self.position.x += x
	self.position.y += y

func make_stealth(stance : bool):
	stealth = stance
	
func die():
	dead = true
	playerSprite.play("Dying")
	
func make_player(order: String):
	match order:
		"stand_up":
			playerSprite.play("Idle-front")
		"idle":
			setIdleDirection()

func _on_end_of_loop_timer_timeout() -> void:
	print("KONIEC LOOPA!")
	playerSprite.play("lying")
	Game_Manager.endLoop(true)
