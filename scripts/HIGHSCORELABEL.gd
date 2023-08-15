extends Label
# INITIATED THE HIGHSCORELABEL BASED OFF THE FILESAVELOAD
func _ready():
	self.text = "HIGH SCORE: " + str(FileSaveLoad.highest_record)
