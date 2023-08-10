extends Node2D

@export
var debug_grid: bool:
	get:
		return debug_grid
	set(value):	
		debug_grid = value
		if $TileMap/GridLabels:
			for label in $TileMap/GridLabels.get_children():
				if value:
					label.show()
				else:
					label.hide()

signal game_over()
# Called when the node enters the scene tree for the first time.
func _ready():
	init_debug_grid()


var desired_position: Vector2 = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (desired_position - position) * delta * 0.5

func _on_snake_game_over_sig():
	# WE WOULD LIKE TO SHOW MESSAGE
	queue_free()
	game_over.emit()


func _on_snake_moved(from, to):
	# position += from - to
	pass


func _on_snake_camera_suggestion(pos):
	desired_position = -pos + Vector2(0.0, 350.0) # TODO: use screensize instead
	
func init_debug_grid():
	for layer in range(5):
		for cell in $TileMap.get_used_cells(layer):
			var tile_size = $TileMap.tile_set.tile_size
			var new_label = $TileMap/GridLabels/Ref.duplicate()
			new_label.text = str(cell)
			new_label.position = $TileMap.map_to_local(Vector2(cell)) - tile_size * 0.25
			if debug_grid:
				new_label.show()
			$TileMap/GridLabels.add_child(new_label)
	
