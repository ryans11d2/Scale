extends Object

class_name LevelData

var level_name: String = ""
var level_scales: int = 1
var level_button: NodePath = ""

var status: int = 0
var attemps: int = 0
var finishes: int = 0
var perfect_finishes: int = 0
var total_time: float = 0
var scales_found: int = 0

var first_time: float = -1
var best_time: float = -1
var feedback: String = ""


func get_data() -> Dictionary:
	
	var data: Dictionary = {}
	
	for i in get_property_list():
		var n = i.name
		if i.name != "script" and i.name != "level_data.gd":
			data[i.name] = get(i.name)
	
	return data

func set_data(new_data: Dictionary):
	
	for i in new_data.keys():
		set(i, new_data[i])
	

func get_info_text() -> String:
	var info: String = ""
	
	info += level_name + "\n"
	
	if status == 0: info += "Incomplete" + "\n"
	elif status == 1: info += "Complete" + "\n"
	elif status == 2: info += "Perfect" + "\n"
	elif status == 3: info += "SUPER" + "\n"
	elif status == 4: info += "SUPER DUPER" + "\n"
	info += "\n"
	
	info += "Attempts: " + str(attemps) + "\n"
	info += "Finishes: " + str(finishes) + "\n"
	info += "Perfects: " + str(perfect_finishes) + "\n"
	info += "\n"
	
	var total_time_parts: Array = [0, 0, 0]
	total_time_parts[0] = fmod(total_time, 60.0)
	total_time_parts[1] = int(total_time / 60) % 60
	total_time_parts[2] = int(total_time / 3600.0)
	var total_time_string: String = "%02d:%02d:%05.2f" % [
		total_time_parts[2], 
		total_time_parts[1], 
		total_time_parts[0]
	]
	
	var best_time_parts: Array = [0, 0, 0]
	best_time_parts[0] = fmod(total_time, 60.0)
	best_time_parts[1] = int(total_time / 60) % 60
	var best_time_string: String = "%02d:%05.2f" % [
		best_time_parts[1], 
		best_time_parts[0], 
	]
	
	info += "Total Time: " + total_time_string + "\n"
	info += "Best Time: " + best_time_string + "\n"
	#info += "Total Scales: " + str(scales_found) + "\n"
	
	return info
