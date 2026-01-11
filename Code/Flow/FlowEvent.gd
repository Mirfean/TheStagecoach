extends Resource
class_name FlowEvent

enum triggers {
	door,
	item_pick,
	item_insert,
	dialogue_started,
	dialogue_finished,
	dialogue_choice,
	chest_open,
	area_entered
}

@export var trigger_type: triggers
@export var trigger_id: String
@export var actions: Array[String]
