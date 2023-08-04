extends Node2D

signal game_over()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_snake_game_over_sig():
	# WE WOULD LIKE TO SHOW MESSAGE
	queue_free()
	game_over.emit()


func _on_snake_moved(from, to):
	position += from - to
