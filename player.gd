extends CharacterBody2D

@onready var label: Label = $"../CanvasLayer/Control/VBoxContainer/Label"
@onready var label_2: Label = $"../CanvasLayer/Control/VBoxContainer/Label2"

const BOMB = preload("uid://c8id523xijugp")
const BOUNCY_BOMB = preload("uid://cvb7r3jh7f8ik")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var movement_velocity: Vector2 = Vector2.ZERO
var knockback_velocity: Vector2 = Vector2.ZERO

@export var explosion_target: Marker2D

func _physics_process(delta: float) -> void:
	
	if not is_on_floor() and knockback_velocity.y <= 0:
		movement_velocity += get_gravity() * delta
	else:
		movement_velocity.y = 0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		movement_velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		if sign_epsilon(knockback_velocity.x) == 0 or sign_epsilon(knockback_velocity.x) == sign(direction):
			movement_velocity.x = direction * SPEED
			label.text = str("is happening ", sign(knockback_velocity.x), " ", sign(direction))
		else:
			label.text = str("is happening ", sign(knockback_velocity.x), " ", sign(direction))
	else:
		movement_velocity.x = move_toward(movement_velocity.x, 0, SPEED)
	
	velocity = movement_velocity + knockback_velocity
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 2000 * delta)
	
	label_2.text = str(knockback_velocity)

	move_and_slide()
	
	if get_last_motion().x == 0:
		knockback_velocity.x = 0
	if get_last_motion().y == 0:
		knockback_velocity.y = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb"):
		var new_bomb = BOUNCY_BOMB.instantiate()
		new_bomb.position = position
		new_bomb.velocity = (get_global_mouse_position() - global_position).normalized() * 500
		new_bomb.player = self
		get_tree().get_root().add_child(new_bomb)

func knockback(source_position: Vector2):
	var initial_movement_velocity = movement_velocity
	var knockback_direction = (explosion_target.global_position - source_position).normalized()
	
	movement_velocity = Vector2.ZERO
	knockback_velocity += snap_to_direction(knockback_direction) * Vector2(600, 1000)

func snap_to_direction(direction: Vector2) -> Vector2:
	var step = TAU / 8.0
	var angle = round(direction.angle() / step) * step
	return Vector2.from_angle(angle) * direction.length()

func sign_epsilon(value: float, epsilon := 0.001) -> int:
	if abs(value) < epsilon:
		return 0
	return sign(value)
