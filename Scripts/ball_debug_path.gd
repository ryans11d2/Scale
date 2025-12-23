@tool
extends Line2D

var debug_file: String = "res://ball_path.txt"

func _enter_tree():
	var file = FileAccess.open(debug_file, FileAccess.READ)
	var new_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	var path_data = new_data["path"]
	
	var new_points: Array = []
	for i in path_data:
		var point_data = (i.substr(1, i.length() - 2)).split(", ")
		var new_point: Vector2 = Vector2.ZERO
		new_point.x = float(point_data[0])
		new_point.y = float(point_data[1])
		new_points.push_back(new_point)
		#var new_point = i
		
	points = new_points
	
	visible = Engine.is_editor_hint()
	
	
