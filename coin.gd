extends Area2D


@export var tile_map: TileMap
@export var grid_location: Vector2


func _ready():
	position = tile_map.map_to_local(grid_location)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_gobbled_up():
	position = tile_map.map_to_local(Vector2(randi_range(0,7), randi_range(0,7)))

