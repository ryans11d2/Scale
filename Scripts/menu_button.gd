extends TextureButton

func _ready() -> void:
	#pivot_offset.x = size.x / 2.0
	#pivot_offset.y = size.y / -2.0
	pass


func _on_mouse_entered() -> void:
	
	pivot_offset = get_global_mouse_position() - global_position
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.1)
	#tween.tween_property(self, "size", Vector2(444, 100), 0.1)
	tween.play()
	
	


func _on_mouse_exited() -> void:
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	tween.play()


func _on_button_down() -> void:
	
	#pivot_offset = get_global_mouse_position() - global_position
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.1)
	tween.play()


func _on_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	tween.play()
