extends SubViewport


@onready var ray_cast_3d: RayCast3D = $"../Player/RayCast3D"



func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if ray_cast_3d.is_colliding():
			print(ray_cast_3d.get_collision_point())
		
