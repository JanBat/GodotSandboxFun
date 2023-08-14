extends AudioStreamPlayer

## when speed increases, so does the soundtrack!
func _on_snake_speed_changed(new_factor):
	pitch_scale = 1 / new_factor
