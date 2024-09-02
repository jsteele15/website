extends Sprite2D

@export var con_1 = Node2D
@export var con_2 = Node2D
@export var rd = Sprite2D

@onready var connected = [con_1, con_2]

var one_active = false
var fired = false

var rn = "road"

func _ready() -> void:
	for c in connected:
		c.visible = false
	rd.visible = false

func _process(delta: float) -> void:
	
	#so this works out if the previous node has been activated
	for c in connected:
		if c.operational == true:
			one_active = true
	
	if one_active == true:
		if fired == false:
			
			for c in connected:
				c.visible = true
			
			rd.visible = true
			fired = true
	
	
	if connected[0].operational == true and connected[1].operational == true:
		rd.modulate = "4b6691"
		
	else:
		rd.modulate = "ffffff"
		

