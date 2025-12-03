extends Resource

class_name GroundSettings

@export_category("Interaction")
@export var physics: PhysicsMaterial = null

@export_category("Fill")
@export var fill_colour: Color = Color.WHITE
@export var fill_texture: Texture = null

@export_category("Edges")
@export var edge_colour: Color = Color.BLACK
@export var edge_texture: Texture = null
@export var edge_width: float = 105.0
