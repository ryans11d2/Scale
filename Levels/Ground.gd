extends StaticBody2D



func _ready():
	
	var tex: Polygon2D
	var col: CollisionPolygon2D
	var lin: Line2D
	
	for i in get_children():
		if i.is_class("Polygon2D"): tex = i
		if i.is_class("CollisionPolygon2D"): col = i
		if i.is_class("Line2D"): lin = i
	
	var polygon: PackedVector2Array = tex.polygon
	col.polygon = polygon
	lin.points = polygon
	

