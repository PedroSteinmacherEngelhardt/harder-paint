extends ColorRect


signal pega_a_cor_ai(cor : Color)


func _on_button_pressed() -> void:
	pega_a_cor_ai.emit(color)
