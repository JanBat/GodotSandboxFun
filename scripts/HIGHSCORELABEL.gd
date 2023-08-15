extends Label
# INITIATED THE HIGHSCORELABEL BASED OFF THE FILESAVELOAD
var FileSaveLoad = load("res://scripts/FileSaveLoad.gd").new()
func _ready():
	self.text = "HIGH SCORE: " + str(FileSaveLoad.load_score())
