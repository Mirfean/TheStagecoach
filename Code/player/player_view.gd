extends PointLight2D
class_name player_vision

var disable_light := false
var disable_rotation := false

func setAngle():
	if not disable_light and not disable_rotation:
		var direction_to_mouse = get_global_mouse_position() - self.global_position
		var direction_normalized = direction_to_mouse.normalized()
		self.rotation = atan2(direction_normalized.y, direction_normalized.x)
	
func dis_light(x : bool):
	disable_light = x
	visible = !disable_light
	
func dis_rotation(x : bool):
	disable_rotation = x
