extends Node2D


###needs to come up when a battle has started
### then go down once it has closed
###done in like five rounds or somthing
## where somthing pops up and changes the battle percentage

@onready var level_info = get_node("/root/GameVars")
var round = 0
var closed = false
var entered = false

###the points for winning or losing a round 
var big_win = 40
var small_win = 20
###confed does more damage to buff
var con_big_win = 60
var con_small_win = 30

####this is to create the timer
var timer_set = false
var results_once = false
var change_once = false
##
var timer;
###list of events that can happen in a battle
###this is enough for now
var event_list = ["cavalry charge", "cannon fire", "musket volley", "flank attack", "feigned retreats", 
	"gatling guns"]
var success_chance = ["very successful", "impressive", "historic", "mid", "effective", "okay", "disappointing", "embarrasing", "disaster"]
#to get a random result each time
var rand_e = RandomNumberGenerator.new()
var rand_s = RandomNumberGenerator.new()

###for deciding battles randomly
var rand_b = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	if level_info.battle_list[level_info.battle_ind][1] == 0 and closed == false:
		
		$BattleCard/bat_name.text = "[center] Battle of {name}[/center]".format({"name":level_info.battle_list[level_info.battle_ind][0]})
		$BattleCard/bat_name2.text = "[center] Battle of {name}[/center]".format({"name":level_info.battle_list[level_info.battle_ind][0]})
		change_once = false
		
		##to fade the battle noises in
		if $battle_sound.volume_db < 1:
			$battle_sound.volume_db += 0.05
		
		if $".".position.y > 180:
			$".".position.y -= 20
		else:
			if timer_set == false:
				$battle_sound.play()
				timer = Timer.new()
				add_child(timer)
				timer.wait_time = 2
				timer.connect("timeout", Callable(self, "battle_round"))
				timer.start()
				timer_set = true
	else:
		
		##to fade the battle noises out
		if $battle_sound.volume_db > -10:
			$battle_sound.volume_db -= 0.25
			
		if $".".position.y < get_viewport_rect().size[1] + 400:
			$".".position.y += 20

		else:
			###so this is for resetting all of the triggers
			if change_once == false:
				$BattleCard/BattleImages.frame = level_info.battle_ind
				if timer != null:
					remove_child(timer)
				$battle_sound.stop()
				closed = false
				timer_set = false
				results_once = false
				round = 0
				change_once = true
				$union.size.x = 200
				$BattleCard/feds.text = ""
				$BattleCard/slavers.text = ""
				$BattleCard/feds/results.text = ""
				$BattleCard/slavers/results.text = ""
				$BattleCard/bat_name2.visible = true
				$BattleCard/bat_name.visible = true

###this is for closing the card
func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and entered == true:
		###this closes the battle thing, will need to reset it at some point, probably with a timer
		closed = true
		level_info.battle_list[level_info.battle_ind][1] = 1
		
		level_info.intel_sent = 1
		
		var save_b = rand_b.randi_range(0, 4+level_info.intel_sent)
		if round < 4:
			if save_b < 4:
				if level_info.date == 1861:
					level_info.cur_lengh -= level_info.year_one
				if level_info.date == 1862:
					level_info.cur_lengh -= level_info.year_two
				if level_info.date == 1863:
					level_info.cur_lengh -= level_info.year_three
				if level_info.date == 1864:
					level_info.cur_lengh -= level_info.year_four
				if level_info.date == 1865:
					level_info.cur_lengh -= level_info.year_five
			else:
				if level_info.date == 1861:
					level_info.cur_lengh += level_info.year_one
				if level_info.date == 1862:
					level_info.cur_lengh += level_info.year_two
				if level_info.date == 1863:
					level_info.cur_lengh += level_info.year_three
				if level_info.date == 1864:
					level_info.cur_lengh += level_info.year_four
				if level_info.date == 1865:
					level_info.cur_lengh += level_info.year_five
			
		if level_info.battle_ind + 1 < 11:
			level_info.battle_ind += 1
		else:
			closed = true
			level_info.game_finish = true
			
func _on_area_2d_mouse_entered() -> void:
	entered = true


func _on_area_2d_mouse_exited() -> void:
	entered = false


###this is for the battle rounds
###right now there is a bug where it gets stuck on a confederate turn
###also the battle just ends if you press close

##00f800 for the green text
func battle_round():
	$BattleCard/bat_name2.visible = false
	$BattleCard/bat_name.visible = false
	if round < 4:
		###doing this so i can use the random number gen in multiple places
		var save_e = rand_e.randi_range(0, len(event_list)-1)
		var save_s = rand_s.randi_range(0, len(success_chance)-1)
		
		if round % 2 == 0:
			$BattleCard/slavers.visible = false
			$BattleCard/feds.visible = true
			round += 1
			$BattleCard/feds.text = "[center] A Union {action} was {result} [/center]".format({"action": event_list[save_e], "result": success_chance[save_s]})
			change_bar("union", save_s)
			#$Camera2D/game_stats/turn.text = "[center] turn: {t} [/center]".format({"t":level_info.turn})
		else:
			$BattleCard/slavers.visible = true
			$BattleCard/feds.visible = false
			round += 1
			$BattleCard/slavers.text = "[center] A Confederate {action} was {result} [/center]".format({"action": event_list[save_e], "result": success_chance[save_s]})
			change_bar("confed", save_s)
	###this is to work out the victory status
	else:
		if results_once == false:
			if $union.size.x >= 239:
				$BattleCard/slavers.visible = false
				$BattleCard/feds.visible = true
				$BattleCard/feds.text = "[center] Union Victory! [/center]"
				$BattleCard/feds/results.text = ""
				if level_info.date == 1861:
					level_info.cur_lengh += level_info.year_one
				if level_info.date == 1862:
					level_info.cur_lengh += level_info.year_two
				if level_info.date == 1863:
					level_info.cur_lengh += level_info.year_three
				if level_info.date == 1864:
					level_info.cur_lengh += level_info.year_four
				if level_info.date == 1865:
					###nerfed year five as the last battle can be far too damaging
					level_info.cur_lengh += level_info.year_four
				
			if $union.size.x <239 and $union.size.x >190:
				$BattleCard/slavers.visible = false
				$BattleCard/feds.visible = true
				$BattleCard/feds.text = "[center] Stalemate [/center]"
				$BattleCard/feds/results.text = ""
				
			if $union.size.x <= 190:
				$BattleCard/slavers.visible = true
				$BattleCard/feds.visible = false
				$BattleCard/slavers.text = "[center] Confederate Victory! [/center]"
				$BattleCard/slavers/results.text = ""
				if level_info.date == 1861:
					level_info.cur_lengh -= level_info.year_one
				if level_info.date == 1862:
					level_info.cur_lengh -= level_info.year_two
				if level_info.date == 1863:
					level_info.cur_lengh -= level_info.year_three
				if level_info.date == 1864:
					level_info.cur_lengh -= level_info.year_four
				if level_info.date == 1865:
					###nerfed year five as the last battle can be far too damaging
					level_info.cur_lengh -= level_info.year_four
			results_once = true
				
func change_bar(side, result):
	if side == "union":
		if result <= 2:
			var change = level_info.bar_overflow($union.size.x, big_win * level_info.intel_sent, $confed.size.x)
			$union.size.x += change
			var for_text = big_win * level_info.intel_sent
			$BattleCard/feds/results.text = "[center] 40 base * {numint} for intel = {res} damage to Confederacy[/center]".format({"numint": level_info.intel_sent, "res": for_text})
		if result > 2 and result < 6:
			var change = level_info.bar_overflow($union.size.x, small_win * level_info.intel_sent, $confed.size.x)
			$union.size.x += change
			var for_text = small_win * level_info.intel_sent
			$BattleCard/feds/results.text = "[center] 20 base * {numint} for intel = {res} damage to Confederacy[/center]".format({"numint": level_info.intel_sent, "res": for_text})
		if result >= 6:
			
			$union.size.x -= con_small_win / level_info.intel_sent
			var for_text = con_small_win / level_info.intel_sent
			$BattleCard/feds/results.text = "[center] 20 base / {numint} for intel = {res} damage to the Union[/center]".format({"numint": level_info.intel_sent, "res": for_text})
	if side == "confed":
		if result <= 2:
			$union.size.x -= con_big_win / level_info.intel_sent
			var for_text = con_big_win / level_info.intel_sent
			$BattleCard/slavers/results.text = "[center] 40 base / {numint} for intel = {res} damage to the Union[/center]".format({"numint": level_info.intel_sent, "res": for_text})
		if result > 2 and result < 6:
			$union.size.x -= con_small_win / level_info.intel_sent
			var for_text = con_small_win / level_info.intel_sent
			$BattleCard/slavers/results.text = "[center] 20 base / {numint} for intel = {res} damage to the Union[/center]".format({"numint": level_info.intel_sent, "res": for_text})
		if result >= 6:
			var change = level_info.bar_overflow($union.size.x, small_win * level_info.intel_sent, $confed.size.x)
			$union.size.x += change
			var for_text = small_win * level_info.intel_sent
			$BattleCard/slavers/results.text = "[center] 40 base * {numint} for intel = {res} damage to the Confederacy[/center]".format({"numint": level_info.intel_sent, "res": for_text})

