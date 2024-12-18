@tool
extends Area2D

@export var power = 0

var last_box = Vector2.ZERO
var change = false
var push_change = 0

var last_pow = 0

func _ready():
	$AnimatedSprite2D.autoplay
	$AnimatedSprite2D.play("new_animation")
	

func _enter_tree():
	
	set_process(Engine.is_editor_hint())
	
	if !Engine.is_editor_hint(): return
	
	last_box = $CollisionShape2D.shape.size
	last_pow = power
	
	#$GPUParticles2D.process_material = load("res://fan_material.material").duplicate()
	
	if !$CollisionShape2D.is_connected("item_rect_changed", area_changed):
		$CollisionShape2D.connect("item_rect_changed", area_changed)
	
	
	

func _physics_process(_delta):
	if !Engine.is_editor_hint():
		if has_overlapping_bodies():
			get_overlapping_bodies()[0].apply_force(Vector2.from_angle(rotation) * power)

func _on_body_entered(body):
	$Audio.play()
		

func _process(delta):
	
	if last_box != $CollisionShape2D.shape.size or last_pow != power:
		last_box = $CollisionShape2D.shape.size
		last_pow = power
		push_change = 0
		change = true
		
	
	if change:
		push_change += delta
		
		if push_change >= 1:
			change = false
			area_changed()
		
	

func area_changed():
	print("Fan Changed")
	#-100 Area Size
	#-60 Viewbox
	
	var par: GPUParticles2D = $GPUParticles2D
	var sha: CollisionShape2D = $CollisionShape2D
	
	par.visibility_rect = Rect2(-60, -140, 60 + (sha.shape.size.x - 100), 288)
	
	par.process_material.initial_velocity_max = power * 0.255
	par.process_material.initial_velocity_min = power * 0.255
	
	
	var dist: float = sha.shape.size.x - 100
	var speed: float = par.process_material.initial_velocity_min
	
	par.lifetime = dist / speed
	par.preprocess = dist / speed
	
	#par.visibility_rect.width = 60 + (sha.shape.size.x - 100)
	




