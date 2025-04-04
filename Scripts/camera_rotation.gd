extends Node2D

var screen_size:Vector2i
var height
var width
var mid:Vector2i
@onready var inner: Node3D = $"../Outer/Inner"
@export var sense:float = 0.5

func _ready() -> void:
	screen_size = DisplayServer.window_get_size()
	height = screen_size.y
	width = screen_size.x
	mid = screen_size / 2

func _input(event: InputEvent) -> void:
	var mouse_pos:Vector2i = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and event is InputEventMouseMotion:
		
		var rot_y = (mid.y - mouse_pos.y)
		var rot_x = (mid.x - mouse_pos.x)
		inner.rotation_degrees = Vector3(rot_y, rot_x, 0) * sense #idek why it works like that
	
