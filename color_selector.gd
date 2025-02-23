extends StaticBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var sub_viewport: SubViewport = $"../SubViewport"

func ray(a,event):
	if event is not InputEventMouse:
		sub_viewport.push_input(event)
		return
	
	var local_point = to_local(a)
	
	var aabb = mesh_instance_3d.get_mesh().get_aabb()
	
	var uv_x = (local_point.x - aabb.position.x) / aabb.size.x
	var uv_y = (local_point.y - aabb.position.y) / aabb.size.y
	
	uv_y = 1.0 - uv_y 
	
	var viewportSize = sub_viewport.size
	var mouse_pos = Vector2(uv_x * viewportSize.x, uv_y * viewportSize.y)
	
	event.position = mouse_pos
	event.global_position = mouse_pos
	
	sub_viewport.push_input(event)
