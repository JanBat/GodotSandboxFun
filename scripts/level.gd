extends Node2D


## an optional toggle for debug purposes; 
## when toggled on, displays Labels on each cell
## of the TileMap with its coordinates
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

## used to pass the game over signal from snake to the main game loop
## and clean up the level in the meantime
signal game_over(score)

func _on_game_over_popup_game_end(score):
	# WE WOULD LIKE TO SHOW MESSAGE
	queue_free()
	game_over.emit(score)


# Called when the node enters the scene tree for the first time.
func _ready():
	init_debug_grid()

## create a grid of labels overlayed on top of the TileMap
## to display each cell's position; requires 
## debug_grid to be true to be shown
func init_debug_grid():
	for layer in range(1):
		for cell in $TileMap.get_used_cells(layer):
			var tile_size = $TileMap.tile_set.tile_size
			var new_label = $TileMap/GridLabels/Ref.duplicate()
			new_label.text = str(cell)
			new_label.position = $TileMap.map_to_local(Vector2(cell)) - tile_size * 0.25
			if debug_grid:
				new_label.show()
			$TileMap/GridLabels.add_child(new_label)
## --------------------------------------------------------------------
## GAME MUSIC:
## Main menu, options button, sound check box.  If checked sound will play during game. 
## if unchecked no sound during game.
func play_sound(sound_on):
	if sound_on == true:
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()


