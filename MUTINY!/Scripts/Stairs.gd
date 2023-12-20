extends Node2D

var destination

# Called when the node enters the scene tree for the first time.
func _ready():
	destination = get_node("StairsDestination").get_global_position()
	print(destination)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Teleports player when stair body is entered
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.set_position(destination)
