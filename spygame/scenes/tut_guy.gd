extends Sprite2D

var move_down = false

var entered = false

var speaches = ["[center]Good day, im Grenville M. Dodge, our aim is to help the North win the Civil war by providing military intelligence to the front line.

Press me to continue! [/center]", "[center]At the top you'll see five stats. From left to right:

OP: is Opperation points, you use these to open spy centers and move intel
IG: is information gathered, this tells you have many bits of intel you've gotten to the north
march 1861: is the date
battle: is how long until the next battle
turn: is how many turns youve taken

Press me to continue! [/center]", "[center]At the bottom we have five buttons, from left to right:
An upgrade button to open spy centers (the white circles on the map) opening a center costs 10 OP
The next one closes a center, as a center remains open and does actions it becomes more conspicuous. becoming to conspicuous can be dangerous
clicking on the binoculars then on an active spy center starts an intel mission...

Press me to continue! [/center]", "[center]The fourth button once pressed allows you to move intel (only to active stations next to the current station and at a cost of 10 OP)
And finally the button on the far right ends your turn!

Press me to continue! [/center]", "[center]Press the station upgrade button and click on the white stations. Once its Blue you know the station is activated.

Then press the end turn button (or the space bar)

Press me to continue![/center]", "[center]You gain 10 OP per turn for each station activated. 
Press the third button and then on the station and a telescope should appear. This shows you that a station is currently gathering information.

Then press the end turn button five times

Press me to continue![/center]", "[center]You should now have some intelligence to send north. Once you've used a station to gather intelligence, the chances of successfully gathering intelegence there again decreases (indicated by the number next to the station). Drag the intelligence either directly to the North, or to the next station active station, and then onto the north!

Press me to continue![/center]", 
"[center]Now that we've given over some intelligence, Press end turn until the next battle commences!

Once that appears, me to continue![/center]", "[center]You've finished the tutorial, the degree to which one side has an advantage in battle depends on how much intelligence you've smuggled to the north. This number resets after every battle. Once all the battles have been won or lost, whoever won the most comes out victorious. 

Press me to return to the main menu and play the game. Good Luck![/center]"]

var current_speach = 0

func _ready() -> void:
	$"../EndContainer".position.x = get_viewport_rect().size[0] -300
	$".".position.x = get_viewport_rect().size[0]  -168

func _process(delta: float) -> void:
	$"../EndContainer/RichTextLabel".text = "{speach}".format({"speach": speaches[current_speach]})
	
	if $TutGuy.position.y == 20:
		move_down = false
		
	if $TutGuy.position.y == -2:
		move_down = true
	
	if move_down == true:
		$TutGuy.position.y += 2
	else:
		$TutGuy.position.y -= 2
	

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and entered == true:
		if current_speach < 8:
			current_speach += 1
		else:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_area_2d_mouse_entered() -> void:
	entered = true


func _on_area_2d_mouse_exited() -> void:
	entered = false
