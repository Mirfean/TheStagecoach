extends PointLight2D

func setAngle():
	var direction_to_mouse = get_global_mouse_position() - self.global_position
	var direction_normalized = direction_to_mouse.normalized()
	self.rotation = atan2(direction_normalized.y, direction_normalized.x)
	print(self.rotation)
	
func _process(delta: float) -> void:
	setAngle()
