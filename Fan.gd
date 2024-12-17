extends Area2D

@export var power = 0

func _ready():
	$AnimatedSprite2D.autoplay
	$AnimatedSprite2D.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if has_overlapping_bodies():
		get_overlapping_bodies()[0].apply_force(Vector2.from_angle(rotation) * power)


func _on_body_entered(body):
	$Audio.play()
		
