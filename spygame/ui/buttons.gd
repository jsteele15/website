extends Node2D

@onready var level_info = get_node("/root/GameVars")

@export var fra = 0

#to compare to the level info
@export var activated = 0

@export var size = 296

var change_trig = false
var selected = false
var entered = false

func _ready() -> void:
	$TempButs.frame = fra
	

func _process(delta: float) -> void:
	
	if activated == level_info.current_action:
		selected = true
		
	else:
		selected = false
	
	if selected == true and change_trig == false:
		$TempButs.frame += 1
		change_trig = true
		
	if selected == false and change_trig == true:
		$TempButs.frame -= 1
		change_trig = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and entered == true:
		level_info.current_action = activated
		

func _on_area_2d_mouse_entered() -> void:
	entered = true



func _on_area_2d_mouse_exited() -> void:
	entered = false
