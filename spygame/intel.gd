extends Node2D

@onready var level_info = get_node("/root/GameVars")

#to work out if the intel has been picked up
var selected = false
var entered = false

var current_station = null
var saved_station = null

@onready var saved_area_pos = current_station.position
@onready var new_area_pos = null

var inside = false

#this doesnt work to restrict
#var moves = 1

func _ready() -> void:
	current_station.intel_here = true
	$paper_shuffle.play()

func _process(delta: float) -> void:
	
	#if level_info.new_turn == true:
		#moves = 1
	
	if selected == true:
		$IntelPic.frame = 1
		$".".global_position = get_global_mouse_position()
	else:
		$IntelPic.frame = 0
		if inside == false:
			$".".position = current_station.position
		else:
			if level_info.op - 10 >= 0:
				if current_station != saved_station:
					##this is the cost of moving station
					level_info.op -= 10
					$".".position = new_area_pos
					###this changes whether the current station has intel or not
					###in the new turn it should allow me to 
					current_station.intel_here = false
					#moves = 0
				
					
					current_station = saved_station
					current_station.intel_here = true
					inside = false
			else:
				$".".position = current_station.position
				inside = false
				
	if current_station.operational == false:
		$".".queue_free()
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and entered == true and level_info.current_action == 4:
		selected = true
	if event.is_action_released("left_click") and selected == true:
		selected = false


func _on_area_2d_mouse_entered() -> void:
	entered = true


func _on_area_2d_mouse_exited() -> void:
	entered = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("new_pos"):
		if area.get_parent().operational == true:
			if area.get_parent().new_pos(current_station):
				
				#if moves > 0:
				#if level_info.op - 5 >= 0:
				inside = true
				new_area_pos = area.get_parent().position
				saved_station = area.get_parent()
				#level_info.op -= 5
				$paper_shuffle.play()
			

func is_intel():
	$paper_shuffle.play()
	level_info.intel_sent += 1
	level_info.cul_intel += 1
	$".".queue_free()
