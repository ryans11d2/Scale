@tool
extends StaticBody2D

class_name Ground

@export var live_edit: bool = false

var tex: Polygon2D
var col: CollisionPolygon2D
var lin: Line2D

enum ground_type {
	GRASS = 0,
	DULL = 1,
	ICE = 2,
	BOUNCE = 3,
	STICK = 4,
	KILL = 5
}
@export var type: ground_type = ground_type.GRASS
var current_type: ground_type

func _enter_tree():
	
	for i in get_children():
		if i.is_class("Polygon2D"): tex = i
		if i.is_class("CollisionPolygon2D"): col = i
		if i.is_class("Line2D"): lin = i
	
	var polygon: PackedVector2Array = tex.polygon
	col.polygon = polygon
	lin.points = polygon
	
	if !tex.is_connected("item_rect_changed", edit_shape):
		tex.connect("item_rect_changed", edit_shape)
	

func edit_shape():
	if live_edit:
		var polygon: PackedVector2Array = tex.polygon
		col.polygon = polygon
		lin.points = polygon
	

func set_type():
	print("Change Type")
	var new_settings: GroundSettings = Select.ground_settings[type]
	physics_material_override = new_settings.physics
	
	for i in get_children():
		if i is Line2D:
			i.default_color = new_settings.edge_colour
			i.texture = new_settings.edge_texture
			i.width = new_settings.edge_width
		elif i is Polygon2D:
			i.color = new_settings.fill_colour
			i.texture = new_settings.fill_texture
	


func _process(delta: float) -> void:
	
	if live_edit and Engine.is_editor_hint():
		var polygon: PackedVector2Array = tex.polygon
		col.polygon = polygon
		lin.points = polygon
		
		if current_type != type:
			set_type()
			current_type = type
		
	
	
