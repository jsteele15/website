extends Node2D

var operational = true

##a list of roads that can be iterated over to work out if each place has the same road
@export var rd1 : Sprite2D = null
@export var rd2 : Sprite2D = null
@export var rd3 : Sprite2D = null
@export var rd4 : Sprite2D = null
@onready var rd_list = [rd1, rd2, rd3, rd4]

var entered = false
var current_intel = null

var intel_here = false

func new_pos(new_station):
	for i in new_station.rd_list:
		if i != null:
			for l in rd_list:
				if l != null:
					if i == l:
						return true
					


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("is_intel"):
		entered = true
		current_intel = area.get_parent()


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().has_method("is_intel"):
		entered = false


func _on_timer_timeout() -> void:
	if entered == true:
		if current_intel != null:
			if current_intel.current_station == $".":
				current_intel.is_intel()
