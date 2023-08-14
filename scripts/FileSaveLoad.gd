extends Node
#-------------------------------------------------------------------------
# SAVE to user file on device and Load from file
#  High score value
# VARIABLES: 
const saved_file = "user://saved_highscore.dat"
#-------------------------------------------------------------------------
func save_score(score):
	var file = FileAccess.open(saved_file, FileAccess.WRITE)
	file.store_32(score)
	file.close()
# Obtained the one value of highest_record from saved_file.
func load_score():
	var file = FileAccess.open(saved_file, FileAccess.READ)
	if FileAccess.file_exists(saved_file):
		return file.get_32()
	

