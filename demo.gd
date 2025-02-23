extends Node3D

@export var annoying_popup : CanvasLayer


func _on_control_submit() -> void:
	annoying_popup.show_annoying_popup("O pedro é foda", "Dalhe")
