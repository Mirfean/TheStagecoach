extends State
class_name PlayerInventory

@export var my_player : player

var interact : bool = false

func Enter():
	my_player.can_interact = interact
	my_player.speed = 0
	print("Siemano")
	

func Exit():
	my_player.can_interact = !interact
	print("Żegnam")
