extends Node

signal door_opened(door_id)
signal item_picked(item_id)
signal item_inserted(item_id, container_id)
signal dialogue_started(dialogue_id)
signal dialogue_finished(dialogue_id)
signal dialogue_choice(dialogue_id, choice_id)
signal chest_opened(chest_id)
signal area_entered(area_id)


signal trigger_fired(trigger_id)
signal flag_changed(flag_name, value)
