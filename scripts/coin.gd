extends Area2D

signal no_more_space_for_coins()

@export var tile_map: TileMap


func _ready():
	# snap position to grid
	position = tile_map.map_to_local(
		tile_map.local_to_map(position)
	)


func get_gobbled_up():
	var position_candidates = tile_map.get_used_cells(0)
	# remove trees
	position_candidates = position_candidates.filter(
		# layer 1 contains all the trees:
		func(cell): return not tile_map.get_cell_tile_data(1, cell)
	)
	# remove coins and snakes
	for group in ["coin", "snake"]:
		var elements = get_tree().get_nodes_in_group(group)
		var all_element_positions = elements.map(
			func(element): return tile_map.local_to_map(element.position)
		)
		
		position_candidates = position_candidates.filter(
			func(cell): return cell not in all_element_positions
		)
	
	if position_candidates:
		position = tile_map.map_to_local(position_candidates[randi_range(0, len(position_candidates)-1)])
	else:
		no_more_space_for_coins.emit()
		queue_free()

