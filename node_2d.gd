extends CanvasLayer

@export var title_label : Label
@export var details_label : Label
@export var animation : AnimationPlayer


func show_annoying_popup(title_text : String, details_text : String) -> void:
	title_label.text = title_text
	details_label.text = details_text
	animation.play("show_popup")
