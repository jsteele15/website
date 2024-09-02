extends Node2D

@onready var level_info = get_node("/root/GameVars")

##a list of roads that can be iterated over to work out if each place has the same road
@export var rd1 : Sprite2D = null
@export var rd2 : Sprite2D = null
@export var rd3 : Sprite2D = null

@onready var rd_list = [rd1, rd2, rd3]

##this is to show whether station is opperational
var operational = false
var change_trig = true

##ton see if the mouse is over the station
var entered = false
var cost = 10
var power_points = 10

###this is to work out its level of recon or if its currently reconing 
var reconing = false
var recon_lv = 1

###so you cant use the same place over and over again
var percentage = 100
var times_used = 1
###this is to work out if there's intel at a station
var intel_here = false

func _ready() -> void:
	$".".scale = Vector2(0.6, 0.6)


func _process(delta: float) -> void:
	

	if times_used > 1:
		$SpyCenter/perc.visible = true
		
		$SpyCenter/perc.text = "{perc}%".format({"perc": percentage/times_used})
	
	
	if reconing == true:
		$SpyCenter/SpyGlass.visible = true
		if recon_lv > -1:
			$SpyCenter/SpyGlass.frame = recon_lv
	if reconing == false:
		$SpyCenter/SpyGlass.visible = false
	
	###this is for working out if the center is operational or not
	#this changes the whole thing, but really you just want it to be the image and everything else to be constant
	if operational == false:
		$SpyCenter/SpyCenterim.modulate = "ffffff"
		$SpyCenter/SpyGlass.visible = false
		if $SpyCenter.scale.x > 0.7:
			$SpyCenter.scale.x -= 0.01
			$SpyCenter.scale.y -= 0.01
	if operational == true:
		$SpyCenter/SpyCenterim.modulate = "4b6691"
		if $SpyCenter.scale.x < 1.3:
			$SpyCenter.scale.x += 0.3
			$SpyCenter.scale.y += 0.3
		if $SpyCenter.scale.x > 1.4:
			$SpyCenter.scale.x -= 0.01
			$SpyCenter.scale.y -= 0.01


func _input(event: InputEvent) -> void:
	##this allows you to set up a spy center
	if event.is_action_released("left_click") and entered == true and level_info.current_action == 1:
		if cost <= level_info.op and operational == false:
			level_info.op -= cost
			operational = true
			$construction.play()
	
	##this allows you to close said center
	if event.is_action_released("left_click") and entered == true and level_info.current_action == 2:
		if operational == true:
			level_info.op -= 10
			operational = false
			
	if event.is_action_released("left_click") and entered == true and level_info.current_action == 3:
		if operational == true and reconing == false:
			if level_info.op - 5 >= 0:	
				level_info.op -= 5
				reconing = true
				$shush.play()



func _on_area_2d_mouse_entered() -> void:
	entered = true

func _on_area_2d_mouse_exited() -> void:
	entered = false

func new_pos(new_station):
	for i in rd_list:
		for l in new_station.rd_list:
			if i == l and i != null and l != null:
				return true

