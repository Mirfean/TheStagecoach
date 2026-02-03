extends Sprite2D
class_name Aimer

@onready var debug_line: Line2D = $RayCast2D/DebugLine
@onready var smol: Sprite2D = $smol
@onready var weapon_holder: Node2D = $"../../WeaponHolder"

@export var shootPos : Node2D
@export var Lline : Line2D
@export var Rline : Line2D
@export var angle_offset_degrees := 20.0
@export var line_length := 50.0 # Długość obu linii
@export var raycast : RayCast2D
@export var curve : Curve
@export var max_aim_distance : float
@export var min_aim_distance : float
@export var min_spread : float
@export var max_spread : float
@export var current_weapon : _Weapon_


var direction_to_mouse : Vector2
var player_position : Vector2
var angle_offset_radians : float
var base_angle : float
var current_angle

func _ready():
	Lline.points.resize(2)
	Rline.points.resize(2)
	curve.bake()
	print("pointy ", str(curve.point_count))
	
func get_new_weapon(weapon : data_WeaponRange):
	if current_weapon != weapon:
		current_weapon = weapon
		set_new_weapon_values()
	
func set_new_weapon_values():
	max_aim_distance = current_weapon.maxAim
	min_aim_distance = current_weapon.minAim
	min_spread = current_weapon.minSpread
	max_spread = current_weapon.maxSpread

func makeAim():
	smol.position = get_global_mouse_position()
	
func setAngle():
	player_position = shootPos.global_position
	var mouse_position = get_global_mouse_position()
	direction_to_mouse = mouse_position - player_position
	var direction_normalized = direction_to_mouse.normalized()
	base_angle = atan2(direction_normalized.y, direction_normalized.x)

func drewLines():
	var aim_lenght = direction_to_mouse.length()
	line_length = clamp(aim_lenght, min_aim_distance, max_aim_distance)
	angle_offset_degrees = curve.sample_baked(clamp(aim_lenght, min_spread, max_spread)/max_spread)
	#print("angle_offset ", angle_offset_degrees)
	
	angle_offset_radians = deg_to_rad(angle_offset_degrees)
	var left_angle = base_angle + angle_offset_radians
	var right_angle = base_angle - angle_offset_radians

	var left_endpoint = Vector2(cos(left_angle), sin(left_angle)) * line_length
	var right_endpoint = Vector2(cos(right_angle), sin(right_angle)) * line_length

	# Ustaw punkty dla obu linii
	Lline.position = player_position
	Lline.points[0] = weapon_holder.position
	Lline.points[1] = left_endpoint

	Rline.position = player_position
	Rline.points[0] = weapon_holder.position
	Rline.points[1] = right_endpoint
	
func rotate_weapon(weapon : Node2D):
	weapon.position = Vector2.ZERO
	weapon.rotation = base_angle
	
func attack_melee(weapon : Node2D):
	weapon.attack()
	
func get_random_angle() -> float:
	print("attack range")
	current_angle = (base_angle + randf_range(-angle_offset_radians, angle_offset_radians))
	return current_angle

func raycast_shot():
	raycast.position = weapon_holder.position
	raycast.target_position = Vector2(cos(current_angle), sin(current_angle)) * 100
	print(str(raycast.target_position))
	debug_line.send_line(Vector2.ZERO, raycast.target_position)
	if raycast.is_colliding():
		print(raycast.get_collider().name)
		var target = raycast.get_collider()
		if target.is_in_group("enemy"):
			print("wow oponent! ", target.name)
