extends Node2D

@onready var level_info = get_node("/root/GameVars")
###so these will be the exploding shit

##to decide what the image is and what station its linked to
@export var linked_station : Node2D
@export var fra : int

var entered = false

#to decide if the thing should be visible
var active = false

var cost = 150

func _ready() -> void:
	$ExplodableSheet.frame = fra
	$".".visible = false
	
func _process(delta: float) -> void:
	if linked_station.operational == true:
		$".".visible = true

func _input(event: InputEvent) -> void:
	##this allows you to set up a spy center
	if event.is_action_released("left_click") and entered == true and level_info.current_action == 2:
		if cost <= level_info.op:
			level_info.op -= cost
			##want a little animation
			##but for now itll just disapear
			
			#adds to the war score
			level_info.cur_lengh += get_viewport_rect().size[0]/16
			$".".queue_free()

func _on_area_2d_mouse_entered() -> void:
	entered = true

func _on_area_2d_mouse_exited() -> void:
	entered = false
