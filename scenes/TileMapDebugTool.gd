@tool # doesn't necessarily do anything (yet?)
extends TileMap

@export
var debug = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# fix_invalid_tiles()
	if debug:
		for layer in range(5):
			for cell in get_used_cells(layer):
				var tile_size = tile_set.tile_size
				var new_label = $Label.duplicate()
				new_label.text = str(cell)
				new_label.position = map_to_local(Vector2(cell)) - tile_size * 0.25
				new_label.show()
				add_child(new_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
