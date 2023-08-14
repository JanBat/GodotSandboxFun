extends Label

## load file-I/O
var FileSaveLoad = load("res://scripts/FileSaveLoad.gd").new()


## INITIATED THE HIGHSCORELABEL BASED OFF THE FILESAVELOAD
func _ready():
	text = "HIGH SCORE: " + str(FileSaveLoad.load_score())
