extends KinematicBody2D

const TARGET_FPS = 60

export var AIR_RESISTANCE = 1
export var GRAVITY = 8
export var JUMP_FORCE = 200
export var ACCELERATION = 32
export var MAX_SPEED = 96
export var FRICTION = 8

var motion = Vector2.ZERO
var jump_counter = 0

onready var sprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):

	# Update every frame, so much multiply by delta
	
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# Moving left or right
	if x_input != 0:
		if jump_counter == 0:
			animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animationPlayer.play("Idle")

	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_wall() and not is_on_floor():
		animationPlayer.play("Wall_Slide")
		if Input.is_action_just_pressed("ui_up"):
			if jump_counter == 1:
				jump_counter = 2
				motion.y = -JUMP_FORCE
	
	# This function only works when move_and_slide is told which direction is upwards
	elif is_on_floor() and abs(motion.y) <= 8:
		jump_counter = 0
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
		if Input.is_action_just_pressed("ui_up"):
			jump_counter = 1
			motion.y = -JUMP_FORCE
			$Jump_2_Sound.play()
	else:
		if Input.is_action_just_pressed("ui_up"):
			if jump_counter == 1:
				jump_counter = 2
				motion.y = -JUMP_FORCE
				$Jump_1_Sound.play()
		elif (jump_counter == 1):
			if (motion.y <= 0):
				animationPlayer.play("Jump")
			else:
				animationPlayer.play("Fall")
		elif (jump_counter == 2):
			if (motion.y <= 0):
				animationPlayer.play("Double_Jump")
			if (motion.y >= 50):	
				animationPlayer.play("Fall")
		else:
			animationPlayer.play("Fall")

		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE / 2:
			motion.y = -JUMP_FORCE / 2
	
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)


	# Returns the leftover Vector motion (collision = no leftover motion downwards, reset fall  speed)
	motion = move_and_slide(motion, Vector2.UP)

func is_player():
	pass
