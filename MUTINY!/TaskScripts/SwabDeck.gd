extends Node2D

var completed
var interact
var entered
var speed = 5
@onready var progressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	completed = false
	interact = false
	entered = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		interact = true
	if Input.is_action_just_released("Interact"):
		interact = false
	if entered and interact:
		if progressBar.value < progressBar.max_value:
			progressBar.value += speed * get_process_delta_time()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		entered = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		entered = false
