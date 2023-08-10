extends Label
# INITIATED THE HIGHSCORELABEL BASED OFF THE FILESAVELOAD
var score = 0

func _ready():
	self.text = "HIGH SCORE: " + str(FileSaveLoad.highest_record)
