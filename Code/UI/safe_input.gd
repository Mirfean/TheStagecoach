extends CenterContainer
class_name SafeInput

@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var text_edit: LineEdit = $VBoxContainer/TextureRect/TextEdit

signal sent_code
signal close

var regex: RegEx

func _ready() -> void:
	regex = RegEx.new()
	regex.compile("[^0-9]")

func _on_text_edit_text_changed(new_text: String) -> void:
	if new_text.length() == 0:
		return
		
	if not new_text.is_valid_int():
		text_edit.text = regex.sub(new_text, "", true)
		text_edit.caret_column = text_edit.text.length()
		text_edit.grab_focus()

func _on_text_edit_text_submitted(new_text: String) -> void:
	if new_text.length() == 0:
		return
	sent_code.emit(new_text)
			
func close_input():
	text_edit.text = ""
	close.emit()
	
