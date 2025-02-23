extends Control


func _on_color_button_pega_a_cor_ai(cor: Color) -> void:
	Painter.color = cor


func _on_h_slider_value_changed(value: float) -> void:
	Painter.thickness = value
