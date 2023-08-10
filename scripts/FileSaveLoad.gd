extends Node
#-------------------------------------------------------------------------
# SAVE to user file on device and Load from file
#  High score value
# VARIABLES: 
const saved_file = "user://saved_highscore.dat"
var highest_record =0


#-------------------------------------------------------------------------
func _ready():
	load_score()
# Saves one value of highest_record to saved_file
func save_score():
	var file = FileAccess.open(saved_file, FileAccess.WRITE)
	file.store_32(highest_record)
	file.close()
# Obtained the one value of highest_record from saved_file.
func load_score():
	var file = FileAccess.open(saved_file, FileAccess.READ)
	if FileAccess.file_exists(saved_file):
		highest_record = file.get_32()
	

