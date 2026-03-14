extends Area2D

var fx_line: Line2D = null

func _ready() -> void:
	
	for i in get_children():
		if i is Line2D:
			fx_line = i
			break
	
	if fx_line != null:
		fx_line.modulate.a = 0.0
		fx_line.width = 0

func collect():
	$Collect.play()
	if fx_line != null:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(fx_line, "modulate:a", 1.0, 0.05)
		tween.tween_property(fx_line, "width", 8.0, 0.1)
		tween.play()
		await tween.finished
		tween.kill()
		
		tween = get_tree().create_tween()
		tween.tween_property(fx_line, "modulate:a", 0.2, 0.02)
		tween.play()
		await tween.finished
	get_parent().queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	
	if "Ball" in body.name:
		await collect()
