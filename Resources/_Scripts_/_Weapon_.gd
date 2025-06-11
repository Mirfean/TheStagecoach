extends Resource
class_name _Weapon_

enum WEAPONTYPE
{
	NONE,
	MELEE,
	RANGE
}

@export var id: int
@export var weapon_type : WEAPONTYPE
@export var nameW: String
@export var damage: int
@export var weapon : String
