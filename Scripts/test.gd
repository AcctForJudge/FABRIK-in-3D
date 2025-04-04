extends Node3D

var lines = []
var t = 0
var prev = Vector3.ZERO

func create_line(from:Vector3, to:Vector3):
	var line = MeshInstance3D.new()
	var cylinder:ImmediateMesh = ImmediateMesh.new()
	var material:StandardMaterial3D = StandardMaterial3D.new()
	
	cylinder.surface_begin(Mesh.PRIMITIVE_LINES, material)
	cylinder.surface_add_vertex(from)
	cylinder.surface_add_vertex(to)
	cylinder.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	line.mesh = cylinder
	
	add_child(line)
	lines.append(line)

func _process(delta: float) -> void:
	var pos = prev + Vector3.ONE * t
	t = t + 10
	create_line(prev, pos)
	prev = pos
	
