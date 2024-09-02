extends Node2D

@onready var level_info = get_node("/root/GameVars")

var entered = false

func _ready() -> void:
	$".".position.x = get_viewport_rect().size[0]/2 - 300

func _process(delta: float) -> void:
	if level_info.game_finish == true:
		if $".".position.y < 600:
			$".".position.y += 10
			
		if level_info.cur_lengh > get_viewport_rect().size[0]/2 + level_info.year_two:
			##for union victory
			$EndContainer/VictoryFaces.frame = 1
			$EndContainer/result.text = "[center]UNION VICTORY[/center]"
			$EndContainer/exp.text = "[center]Through cunning we've helped to bring the rebellious southern states back into the fold![/center]"
			$EndContainer/time_fin.text = " Date Finished : {month} {date}".format({"month": level_info.month_list[level_info.current_month], "date":level_info.date})
			$EndContainer/int_gath.text = " Intel Gathered : {int}".format({"int":level_info.cul_intel})
		else:
			##for union victory
			$EndContainer/result.text = "[center]CONFEDERATE VICTORY[/center]"
			$EndContainer/exp.text = "[center]Despite our best efforts, the Confederates have won the day![/center]"
			$EndContainer/time_fin.text = " Date Finished : {date}".format({"date":level_info.date})
			$EndContainer/int_gath.text = " Intel Gathered : {int}".format({"int":level_info.cul_intel})
#$BattleCard/bat_name2.text = "[center] Battle of {name}[/center]".format({"name":level_info.battle_list[level_info.battle_ind][0]})

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		#will need to link to main menu
		if entered == true:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_area_2d_mouse_entered() -> void:
	entered = true


func _on_area_2d_mouse_exited() -> void:
	entered = false
