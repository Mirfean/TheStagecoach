extends Control
class_name Achievements

@onready var listHolder: Control = $AchievList
var achiev_list: Array[Achievement]

@export var title_text: RichTextLabel
@export var descr_text: RichTextLabel


func _ready() -> void:
	achiev_list = []
	for child in listHolder.get_children():
		if child is Achievement:
			achiev_list.append(child)
	for x in achiev_list:
		print("%s -> %s" % [x.Title, x.Description])
		x.ShowInfo.connect(ShowInfo)
		x.HideInfo.connect(RemoveInfo)

func ShowInfo(title, descr):
	title_text.text = title
	descr_text.text = descr
	
func RemoveInfo():
	title_text.text = ""
	descr_text.text = ""
