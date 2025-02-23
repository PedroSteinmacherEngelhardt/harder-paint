extends Node3D

@export var annoying_popup : CanvasLayer
@export var canva : StaticBody3D


func _on_control_submit() -> void:
	var batata = canva.compare_image()
	
	if batata > 0.95:
		annoying_popup.show_annoying_popup("Near Perfect!", "I would give you lots of money if I had coded that")
		return
	if batata > 0.90:
		annoying_popup.show_annoying_popup("I've seen better", "I think you deserve some money")
		return
	else:
		annoying_popup.show_annoying_popup("Lmao you suck", "I think you didn't even try, not gonna lie")
		return
