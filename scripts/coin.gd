extends Area2D


@export var tile_map: TileMap
@export var grid_location: Vector2


func _ready():
	position = tile_map.map_to_local(grid_location)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_gobbled_up():
	var position_candidates = tile_map.get_used_cells(0)
	# remove trees
	position_candidates = position_candidates.filter(
		func(cell): return not tile_map.get_cell_tile_data(1, cell)
	)
	# remove coins
	# remove snakesegments
	
	position = tile_map.map_to_local(position_candidates[randi_range(0, len(position_candidates))])

