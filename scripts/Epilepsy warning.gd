extends Node2D

## remove epilepsy warning upon acknowledgement
func _on_button_pressed():
	queue_free()
