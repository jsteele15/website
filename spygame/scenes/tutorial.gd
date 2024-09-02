extends Node2D

@onready var level_info = get_node("/root/GameVars")

###list of nodes for the spycenters
@onready var spy_center_list = [$Camera2D/ConfedMap/spy_centers, $Camera2D/ConfedMap/spy_centers2]

var count_num_active = 0

###to pre load the intel 
var intel_load = preload("res://scenes/intel.tscn")

###for the random percentages
var rand_n = RandomNumberGenerator.new()

func _ready() -> void:
	level_info.tutorial_battle_list = [["Fort Sumer", 10]]
	
	#so that battles can become more consecuential with time
	level_info.cur_lengh = get_viewport_rect().size[0]/2 
	level_info.year_one = get_viewport_rect().size[0]/32
	level_info.year_two = get_viewport_rect().size[0]/16
	level_info.year_three = get_viewport_rect().size[0]/8
	level_info.year_four = get_viewport_rect().size[0]/4
	level_info.year_five = get_viewport_rect().size[0]/2
	
	##move the fed bar to show winning or losing
	$feds.size.x = get_viewport_rect().size[0]/2 
	$conf.size.x = get_viewport_rect().size[0]
	
	###to set the card in the right place
	$battle_card.position.x = get_viewport_rect().size[0]/2 -300
	
func _process(delta: float) -> void:
	if level_info.new_turn == true:
		
		
		##for the months, change the clock
		if level_info.current_month == 11:
			level_info.current_month = 0
			level_info.date += 1
		else:
			level_info.current_month += 1
		
		###to count down until the battle
		if level_info.tutorial_battle_list[level_info.battle_ind][1] > 0:
			level_info.tutorial_battle_list[level_info.battle_ind][1] -= 1
		
		
		
		##this counts how mant active sights there are
		count_num_active = 0
		
		for c in range(len(spy_center_list)):
			if spy_center_list[c].operational == true:
				count_num_active += 1
				##this works out if any of those sights have active intel
				if spy_center_list[c].intel_here == true:
					spy_center_list[c].alertness += 3.2
		
		###this increases your power depending on if theyre active
		for c in range(len(spy_center_list)):
			if spy_center_list[c].operational == true:
				level_info.op += spy_center_list[c].power_points
				
				##this adds alertness to spy centers
				##the idea is that when the alertness gets to 32 it destroys the place
				if spy_center_list[c].alertness < 32:
					
					###this works out if we're activlly reconing
					if spy_center_list[c].reconing == true:
						spy_center_list[c].alertness += 3.2
						
						##the cost for operating
						if level_info.op - 5 >= 0:
							level_info.op -= 5
						else:
							spy_center_list[c].reconing = false
						
						###this adds to the recon level
						if spy_center_list[c].recon_lv < 32:
							spy_center_list[c].recon_lv += 6.4
						
						var save_n = rand_n.randi_range(1, spy_center_list[c].times_used)
						###so if i have a random thing, and it has a list of numbers in
						###from times used it should work
						if spy_center_list[c].recon_lv == 32 and save_n == 1:
							spy_center_list[c].recon_lv = 0
							var intel_inst = intel_load.instantiate()
							spy_center_list[c].times_used += 1
							
							intel_inst.current_station = spy_center_list[c]
							intel_inst.position = spy_center_list[c].position
							intel_inst.saved_area_pos = spy_center_list[c].position
							
							spy_center_list[c].reconing = false
							$Camera2D/ConfedMap.add_child(intel_inst)
						
						##this is for if you fail to do the recon
						if spy_center_list[c].recon_lv == 32 and save_n != 1:
							spy_center_list[c].recon_lv = 0
							spy_center_list[c].reconing = false
						
					if spy_center_list[c].reconing == false:
						#this times it by the number of sights that are active
						spy_center_list[c].alertness += (0.32 * count_num_active)
				else:
					spy_center_list[c].operational = false
					###this sends out a burst of awareness for all centers that are active
					for s in range(len(spy_center_list)):
						if spy_center_list[s].operational == true:
							spy_center_list[s].alertness += 3.2
			
			##this reduces the alertness if the center is deactivated
			if spy_center_list[c].operational == false:
				if spy_center_list[c].alertness > 0:
					###need to change this so i can change the values dynamically and not run over
					spy_center_list[c].alertness -= 3.2
		
		$Camera2D/ui_butts/turnbut.clicked = false
		
		###this is for the tracking stats
		
		$Camera2D/game_stats/year.text = "[center] {month} {year} [/center]".format({"month": level_info.month_list[level_info.current_month], "year":level_info.date})
		$Camera2D/game_stats/turn.text = "[center] Turn: {t} [/center]".format({"t":level_info.turn})
		
		level_info.turn += 1
		level_info.new_turn = false
		
	#placing this here so it changes dynamically
	$Camera2D/game_stats/op_power.text = "[center] OP: {op} [/center]".format({"op":level_info.op})
	$Camera2D/game_stats/battle.text = "[center] Battle in {howl} turns[/center]".format({"howl":level_info.tutorial_battle_list[level_info.battle_ind][1]})
	$Camera2D/game_stats/intel_gathered.text = "[center] IG: {ig} [/center]".format({"ig": level_info.intel_sent})
	##to decrease and increase the size of the bar depending on what the current lengh is
	if $feds.size.x < level_info.cur_lengh:
		$feds.size.x += 2
	if $feds.size.x > level_info.cur_lengh:
		$feds.size.x -= 2
		
	###to move the ui down when a battle is happening
	if level_info.tutorial_battle_list[level_info.battle_ind][1] == 0 and $Camera2D/ui_butts.position.y < get_viewport_rect().size[1] + 360 and level_info.game_finish != true:
		$Camera2D/ui_butts.position.y += 20
	if level_info.tutorial_battle_list[level_info.battle_ind][1] != 0 and $Camera2D/ui_butts.position.y > get_viewport_rect().size[1] and level_info.game_finish != true:
		$Camera2D/ui_butts.position.y -= 20
	
	###this needs to keep on reseting, because otherwise when this is implemented it wont work
	$Camera2D/ConfedMap/north.intel_here = false
	
	if level_info.tutorial_battle_list[level_info.battle_ind][1] == 0:
		if $battle_card.position.y > 200:
			$battle_card.position.y -= 10
			
	
	###to modulate the cover
	if level_info.tutorial_battle_list[level_info.battle_ind][1] == 0 or level_info.game_finish == true:
		if $fader.modulate.a < 0.8:
			$fader.modulate.a += 0.01
	
	else:
		if $fader.modulate.a > 0:
			$fader.modulate.a -= 0.01

###this is to test if restarting works, it looks like it does
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
