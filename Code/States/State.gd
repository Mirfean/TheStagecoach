extends Node
class_name State

signal Transitioned

#Nie dodawać warunków z wracaniem do poprzedniego state
func Enter():
	pass
	
func Exit():
	pass
	
func InputState(event: InputEvent):
	pass

func Update(_delta : float):
	pass

func PhysicsUpdate(_delt : float):
	pass
