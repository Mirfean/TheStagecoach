extends AwarenessState
class_name EnemyAttack

@export var cooldown_after : float
@export var damage : int
@export var damage_collision : CollisionShape2D
@export var animation_player : AnimationPlayer

var attack_direction: Vector2
var can_attack : bool
var can_damage : bool

func _ready() -> void:
	can_attack = true

func Enter():
	#print("enemy attack")
	if not can_attack:
		Transitioned.emit(self, 'Follow')
	if player_char == null:
		player_char = get_tree().get_first_node_in_group("player")
	#print("enemy attack in progress")
	enemy_character.velocity = Vector2.ZERO
	can_damage = true
	animation_player.play("Attack")
	if not animation_player.animation_finished.is_connected(end_attack):
		animation_player.animation_finished.connect(end_attack)
	attack_direction = player_char.global_position - enemy_character.global_position
	
func Exit():
	if can_attack:
		can_attack = false
	
func PhysicsUpdate(delta: float):
	super.PhysicsUpdate(delta)
	enemy_character.velocity = attack_direction.normalized() * move_speed
	
func end_attack(something):
	enemy_character.velocity = Vector2.ZERO
	timer.start(cooldown_after)
	enemy_character.cooldown()
	Transitioned.emit(self, 'Follow')

func _on_timer_timeout() -> void:
	can_attack = true
	


func _on_attack_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_damage:
		body.getDamage(damage)
		can_damage = false
