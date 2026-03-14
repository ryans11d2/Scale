extends Object

class_name LevelData

var level_name: String = ""
var level_scales: int = 1
var level_button: NodePath = ""

var status: int = 0
var attemps: int = 0
var finishes: int = 0
var perfect_finishes: int = 0
var total_time: float
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
	
