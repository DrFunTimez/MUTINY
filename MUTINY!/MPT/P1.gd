extends CharacterBody2D


const SPEED =120
const JUMP_VELOCITY = -400.0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$MultiPlayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	var velocity = 0
func _physics_process(delta):
	if $MultiPlayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
