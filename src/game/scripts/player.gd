class_name Player

extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

signal key_used
var has_key: bool = false

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -400.0

enum State { Idle, Run, Jump }

var current_state: State = State.Idle

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func player_idle(delta: float):
	if is_on_floor():
		current_state = State.Idle

func player_run(delta: float):
	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip the Sprite
	if direction != 0:
		if is_on_floor():
			current_state = State.Run
		animated_sprite.flip_h = false if direction > 0 else true

func player_falling(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta

func player_jump(delta: float):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.Jump

	if not is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x += direction * SPEED * delta

func player_animations():
	match current_state:
		State.Idle:
			animated_sprite.play("idle")
		State.Jump:
			animated_sprite.play("jump_loop")
		State.Run:
			animated_sprite.play("walk")

func _physics_process(delta: float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)

	player_animations()
	move_and_slide()
