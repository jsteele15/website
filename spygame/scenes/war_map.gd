extends Node2D

@onready var level_info = get_node("/root/GameVars")

###list of nodes for the spycenters
@onready var spy_center_list = [$Camera2D/ConfedMap/spy_centers3, $Camera2D/ConfedMap/spy_centers2, $Camera2D/ConfedMap/spy_centers,
	$Camera2D/ConfedMap/spy_centers4, $Camera2D/ConfedMap/spy_centers5, $Camera2D/ConfedMap/spy_centers6, $Camera2D/ConfedMap/spy_centers7,
	$Camera2D/ConfedMap/spy_centers8, $Camera2D/ConfedMap/spy_centers9, $Camera2D/ConfedMap/spy_centers10, $Camera2D/ConfedMap/spy_centers11]

var count_num_active = 1
var count_num_recon = 0

###to pre load the intel 
var intel_load = preload("res://scenes/intel.tscn")

###for the random percentages
var rand_n = RandomNumberGenerator.new()

##power gain per sight thats open
var op_gain = 5
var rec_cost = 20

func _ready() -> void:
	###just messing around with scaleing the map
	#$Camera2D/ConfedMap.scale = Vector2(1, 1)
	##needs to change the location of the map as well though
	
	###this is to reset the game if you play it multiple times
	
	level_info.intel_sent = 1
	level_info.cul_intel = 0
	level_info.turn = 1
	level_info.date = 1861
	level_info.op = 10
	level_info.new_turn = true
	level_info.current_month = 1
	level_info.battle_list = [["Fort Sumter", 2], ["Bull Run", 3], ["Shiloh", 9], ["Anietam", 5], ["Fredericksburg", 3], ["Chancellorsville", 4],
	["Gettysburg", 3], ["Chickamauga", 2], ["Lookout Mountain", 2], ["Atlanta", 8], ["Appomattox station", 9]]
	level_info.battle_ind = 0
	level_info.current_action = 0
	level_info.game_finish = false
	level_info.alertness = 0
	
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
	
	##this is for the alertness bar
	$fill.size.x = 0
	$back_bar.size.x = get_viewport_rect().size[0]
	$fill.position.y = get_viewport_rect().size[1] 
	$back_bar.position.y = get_viewport_rect().size[1] 
	
	
	###to set the card in the right place
	$battle_card.position.x = get_viewport_rect().size[0]/2 -300
	$battle_card.position.y = get_viewport_rect().size[1] + 400
	
func _process(delta: float) -> void:
	##this counts how mant active sights there are
	count_num_active = 1
	count_num_recon = 0
	
	for c in range(len(spy_center_list)):
		if spy_center_list[c].operational == true:
			count_num_active += 1
			if spy_center_list[c].reconing == true:
				count_num_recon += 1
	
	if level_info.new_turn == true:
		
		
		##for the months, change the clock
		if level_info.current_month == 11:
			level_info.current_month = 0
			level_info.date += 1
		else:
			level_info.current_month += 1
		
		###to count down until the battle
		if level_info.battle_list[level_info.battle_ind][1] > 0:
			level_info.battle_list[level_info.battle_ind][1] -= 1
		
		for c in range(len(spy_center_list)):
			if spy_center_list[c].operational == true:
				
				##this works out if any of those sights have active intel
				if spy_center_list[c].intel_here == true:
					level_info.alertness += get_viewport_rect().size[0]/32
		
		###this increases your power depending on if theyre active
		for c in range(len(spy_center_list)):
			if spy_center_list[c].operational == true:
				
				
				##this adds alertness to spy centers
				##the idea is that when the alertness gets to be full
				#turning this off for now, so i can test other stuff
				if level_info.alertness < 1000000000000:#get_viewport_rect().size[0]:
					
					###this works out if we're activlly reconing
					if spy_center_list[c].reconing == true:
						level_info.alertness += get_viewport_rect().size[0]/32
						
						##the cost for operating
						if level_info.op - 5 >= 0:
							level_info.op -= 5
						else:
							spy_center_list[c].reconing = false
						
						###this adds to the recon level
						if spy_center_list[c].recon_lv > -1:
							spy_center_list[c].recon_lv -= 1
						
						var save_n = rand_n.randi_range(1, spy_center_list[c].times_used)
						###so if i have a random thing, and it has a list of numbers in
						###from times used it should work
						if spy_center_list[c].recon_lv == -1 and save_n == 1:
							spy_center_list[c].recon_lv = 1
							var intel_inst = intel_load.instantiate()
							spy_center_list[c].times_used += 1
							
							intel_inst.current_station = spy_center_list[c]
							intel_inst.position = spy_center_list[c].position
							intel_inst.saved_area_pos = spy_center_list[c].position
							
							spy_center_list[c].reconing = false
							$Camera2D/ConfedMap.add_child(intel_inst)
						
						##this is for if you fail to do the recon
						if spy_center_list[c].recon_lv == -1 and save_n != 1:
							spy_center_list[c].recon_lv = 1
							spy_center_list[c].reconing = false
						
					if spy_center_list[c].reconing == false:
						#might want to add something here
						level_info.alertness += get_viewport_rect().size[0]/64
						
				else:
					pass
					###need to change this around
					###so that when the allertness gets too high it closes some of the centers
					#spy_center_list[c].operational = false
					###this sends out a burst of awareness for all centers that are active
					#for s in range(len(spy_center_list)):
						#if spy_center_list[s].operational == true:
							#level_info.alertness += get_viewport_rect().size[0]/32
			
		###at the end of the turn it gives you your op
			
		level_info.op += (op_gain * count_num_active) - (rec_cost * count_num_recon)
			
		
		$Camera2D/ui_butts/turnbut.clicked = false
		
		###this is for the tracking stats
		
		$Camera2D/game_stats/year.text = "[center] {month} {year} [/center]".format({"month": level_info.month_list[level_info.current_month], "year":level_info.date})
		$Camera2D/game_stats/turn.text = "[center] Turn: {t} [/center]".format({"t":level_info.turn})
		
		level_info.turn += 1
		level_info.new_turn = false
		
	#placing this here so it changes dynamically
	if (op_gain * count_num_active) - (rec_cost * count_num_recon) >= 0:
		$Camera2D/game_stats/op_power.text = "[center] OP: {op} + {change} [/center]".format({"op":level_info.op, "change":(op_gain * count_num_active) - (rec_cost * count_num_recon)})
	else:
		$Camera2D/game_stats/op_power.text = "[center] OP: {op} {change} [/center]".format({"op":level_info.op, "change":(op_gain * count_num_active) - (rec_cost * count_num_recon)})
	
	$Camera2D/game_stats/battle.text = "[center] Battle in {howl} turns[/center]".format({"howl":level_info.battle_list[level_info.battle_ind][1]})
	$Camera2D/game_stats/intel_gathered.text = "[center] IG: {ig} [/center]".format({"ig": level_info.intel_sent})
	##to decrease and increase the size of the bar depending on what the current lengh is
	if $feds.size.x < level_info.cur_lengh:
		$feds.size.x += 2
	if $feds.size.x > level_info.cur_lengh:
		$feds.size.x -= 2
		
	###to move the ui down when a battle is happening
	if level_info.battle_list[level_info.battle_ind][1] == 0 and $Camera2D/ui_butts.position.y < get_viewport_rect().size[1] + 360 and level_info.game_finish != true:
		$Camera2D/ui_butts.position.y += 20
	if level_info.battle_list[level_info.battle_ind][1] != 0 and $Camera2D/ui_butts.position.y > 220 and level_info.game_finish != true:
		$Camera2D/ui_butts.position.y -= 20
	
	###this needs to keep on reseting, because otherwise when this is implemented it wont work
	$Camera2D/ConfedMap/north.intel_here = false
	
	###to modulate the cover
	if level_info.battle_list[level_info.battle_ind][1] == 0 or level_info.game_finish == true:
		if $fader.modulate.a < 0.8:
			$fader.modulate.a += 0.01
	
	else:
		if $fader.modulate.a > 0:
			$fader.modulate.a -= 0.01
			
	if $feds.size.x >= get_viewport_rect().size[0]:
		level_info.game_finish = true
		$battle_card.closed = true
	
	###this fills and reduces the alertness bar
	if $fill.size.x < level_info.alertness:
		$fill.size.x += 2
	#this needs more work so it doesnt jump around
	#if $fill.size.x > level_info.alertness:
		#$fill.size.x -= 20

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
