extends Control

###this will control the layout of the ui on the screen

@onready var button_list = [$upgrade, $close, $recon, $count, $intel, $turnbut]

func _ready() -> void:
	
	$".".position.y = 220 #get_viewport_rect().size[1] + 40
	
	$".".size.x = get_viewport_rect().size[0]
	$".".size.y = get_viewport_rect().size[1]
	#works out the size of the map then places the buttons in the relevant areas
	var cut_but_x = get_viewport_rect().size[0] /5
	var cut_but_y = get_viewport_rect().size[1] /6
	for b in range(len(button_list)):
		if b <= 4:
			button_list[b].position.y = cut_but_y * (b ) 
			button_list[b].position.x = get_viewport_rect().size[0] - button_list[b].size
		else:
			button_list[b].position.y = cut_but_y * (b -1) 
			button_list[b].position.x = - 30 
		
	
