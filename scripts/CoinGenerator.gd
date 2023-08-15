extends Node2D


@export
var coin_count = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(coin_count - 1):
		var new_coin = $Coin.duplicate()
		add_child(new_coin)
	
