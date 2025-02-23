extends StaticBody3D

@export var ICON : Texture2D
@export var final_icon : Texture2D

@onready var player : CharacterBody3D = $"../Player"
@onready var front: MeshInstance3D = $Front
@onready var camera =  $"../Player".get_node("Camera3D")


var material: StandardMaterial3D
var image: Image
var origin_image: Image
var final_image: Image

var random = randi()

var last_pixel


func _ready():
	image = ICON.get_image()
	if image.is_compressed():
		image.decompress()
	image.convert(Image.FORMAT_RGBA8)
	
	final_image = final_icon.get_image()
	if final_image.is_compressed():
		final_image.decompress()
	final_image.convert(Image.FORMAT_RGBA8)
	
	origin_image = image.duplicate()
	material = front.get_active_material(0)
	material.set_texture(0, ICON)


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		compare_image()
	
	if Input.is_action_pressed("click"):
		cast_ray()
	else:
		last_pixel = null


func compare_image():
	var i = 0.0
	for x in range(256):
		for y in range(256):
			var image_pixel = image.get_pixel(x,y)
			var compare_pixel = final_image.get_pixel(x,y)
			
			if image_pixel.a == 0:
				image_pixel = origin_image.get_pixel(x,y)
			
			if image_pixel == compare_pixel:
				i += 1
	var result = i/(256*256)
	print(result)
	return result


func cast_ray():
	if player.global_position.distance_to(global_position) > 5.5:
		return
	
	var ray_origin = camera.global_transform.origin
	var ray_direction = -camera.global_transform.basis.z 
	var aabb = front.get_mesh().get_aabb()
	var local_ray_origin = front.to_local(ray_origin)
	var local_ray_direction = front.to_local(ray_origin + ray_direction) - local_ray_origin
	
	if aabb.intersects_ray(local_ray_origin, local_ray_direction):
		var intersection_point = aabb.intersects_ray(local_ray_origin, local_ray_direction) + position
		set_intersection_pixel(intersection_point)


func set_intersection_pixel(intersection_point: Vector3):
	var local_point = front.to_local(intersection_point + front.position)
	var aabb = front.get_mesh().get_aabb()

	var uv_x = (local_point.x - aabb.position.x) / aabb.size.x
	var uv_y = (local_point.y - aabb.position.y) / aabb.size.y

	uv_y = 1.0 - uv_y 

	var img_width = image.get_size().x
	var img_height = image.get_size().y
	
	var pixel := Vector2(int(uv_x * img_width), int(uv_y * img_height))
	pixel.clamp(Vector2.ZERO, Vector2(img_width - 1, img_height - 1))
	
	#image.set_pixel(pixel.x, pixel.y, Color.RED)
	
	#material.set_texture(0, ImageTexture.create_from_image(image))
	if last_pixel:
		draw_line(last_pixel, pixel)
	
	last_pixel = pixel
	

func draw(point: Vector2, should_set_pixel = false):
	point = point.clamp(Vector2.ZERO, Vector2(image.get_size().x - 1, image.get_size().y - 1))
	
	var size = Painter.thickness
	
	if should_set_pixel:
		image.set_pixel(point.x, point.y, Painter.color)
	else:
		image.fill_rect(Rect2i(int(point.x) - size/2,int(point.y) - size/2, size,size), Painter.color)


func draw_line(point1: Vector2, point2: Vector2):
	var points = []
	var half_thickness = 1
	# Bresenham's line algorithm to get the base line points
	var x0 = int(point1.x)
	var y0 = int(point1.y)
	var x1 = int(point2.x)
	var y1 = int(point2.y)
	
	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 1 if x0 < x1 else -1
	var sy = 1 if y0 < y1 else -1
	var err = dx - dy
	
	
	while true:
		points.append(Vector2(x0, y0))
		
		if x0 == x1 and y0 == y1:
			break
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy
	
	draw_circle(point1)
	draw_circle(point2)
	
	for p in points:
		draw(p)
	material.set_texture(0, ImageTexture.create_from_image(image))
	


func draw_circle(center: Vector2):
	var points = {}
	var r = Painter.thickness/ 1.3
	
	for radius in range(r):
		for angle in range(360):
			var x1 = int(radius * cos(angle * PI/180))
			var x2 = int(radius * sin(angle * PI/180))
			
			var v = abs(x1) + abs(x2)
			
			if v > r*1.5:
				continue
			
			points[Vector2(center.x + x1, center.y + x2)] = true
	
	
	for p in points.keys():
		draw(p, true)
	material.set_texture(0, ImageTexture.create_from_image(image))


func _on_h_slider_value_changed(value: float) -> void:
	print(value)
	Painter.radius = value
	Painter.thickness = value
