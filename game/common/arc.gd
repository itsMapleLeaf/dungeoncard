tool
extends Node2D
class_name Arc

export var radius: float = 32
export(float, 0, 360) var angle_from: float = 0
export(float, 0, 360) var angle_to: float = 100
export var color: Color = Color.white
export var point_count: int = 32

# empty UVs var because we don't need these, but need the other arguments
var uvs := PoolVector2Array()

func _process(_delta):
	update()

func _draw():
	var points_arc := PoolVector2Array()
	points_arc.push_back(Vector2.ZERO)

	for i in point_count + 1:
		var angle_point := deg2rad(angle_from + i * (angle_to - angle_from) / point_count - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * radius)

	draw_polygon(points_arc, PoolColorArray([color]), uvs, null, null, true)
