extends Node

###this is a force multiplyer for the battles
var intel_sent = 1
var cul_intel = 0
var alertness = 0
#this works out the current size of the bar and how close to union victory or loss
### the amount you can win increases each time
var cur_lengh = null
var year_one = null
var year_two = null
var year_three = null
var year_four = null
var year_five = null

##turn for the game
var turn = 1
var date = 1861
var op = 10
var new_turn = true
##use this to make all the ui wait for the battle
#needs implementing though
var waiting = false

###for the months of the year
var month_list = ["Jan", "Feb", "March", "April", "May" ,"June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
#remember zero index please
var current_month = 1
##this is for the battles you prepare for
##so, we've got the battle name, and then how many months until that battle happens, the months will need to come down each turn
var battle_list = [["Fort Sumter", 2], ["Bull Run", 3], ["Shiloh", 9], ["Anietam", 5], ["Fredericksburg", 3], ["Chancellorsville", 4],
	["Gettysburg", 3], ["Chickamauga", 2], ["Lookout Mountain", 2], ["Atlanta", 8], ["Appomattox station", 9]]
var battle_ind = 0

###for the tutorial specifically
var tutorial_battle_list = [["Fort Sumer", 10]]

##this is to do selected options
# 1 = upgrade or open center, 2 = is for closing one, 3 = recon, 4 = steal intel
var current_action = 0

###to tell when the game is finished
var game_finish = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
		
	if event.is_action_pressed("upbut"):
		current_action = 1
		
	if event.is_action_pressed("downbut"):
		current_action = 2
		
	if event.is_action_pressed("recbut"):
		current_action = 3
		
	if event.is_action_pressed("opbut"):
		current_action = 4
		
	if event.is_action_pressed("newturn"):
		new_turn = true

###a function to work out if adding something will make a bar too thic
func bar_overflow(start, num_in, maxim):
	if start + num_in > maxim:
		var to_add = maxim - start
		return  to_add
		
	else:
		return  num_in
	
