@tool
extends StaticBody2D

@export var live_edit: bool = false

var tex: Polygon2D
var col: CollisionPolygon2D
var lin: Line2D

func _enter_tree():
	print("GROUND")
	
	for i in get_children():
		if i.is_class("Polygon2D"): tex = i
		if i.is_class("CollisionPolygon2D"): col = i
		if i.is_class("Line2D"): lin = i
	
	var polygon: PackedVector2Array = tex.polygon
	col.polygon = polygon
	lin.points = polygon
	
	tex.connect("item_rect_changed", edit_shape)
	

func edit_shape():
	if live_edit:
		var polygon: PackedVector2Array = tex.polygon
		col.polygon = polygon
		lin.points = polygon
	

func _process(delta: float) -> void:
	
	if live_edit and Engine.is_editor_hint():
		var polygon: PackedVector2Array = tex.polygon
		col.polygon = polygon
		lin.points = polygon
	
	
