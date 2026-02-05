extends Node
class_name TileHandler


# OBSOLETE??

@export var tileParts: Dictionary[int, PackedScene]
const PATH = "res://Scenes/TileParts/"

func _ready() -> void:
	load_tile_parts()

func load_tile_parts():
	# Take all Scenes from "res://Scenes/TileParts/"
	print("loading")

# Spawn TilePart and set to certain point


func remove_tile_part(tilePart: TilePart):
	#Cleaning
	tilePart.queue_free()
