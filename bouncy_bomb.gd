extends CharacterBody2D
@onready var progress_bar: TextureProgressBar = $TextureProgressBar

const EXPLOSION = preload("uid://ct43nc1ho8wgx")

var player: CharacterBody2D

@export var explosion_timer: Timer

var bounces = 0

func _ready() -> void:
	explosion_timer.paused = true
	progress_bar.max_value = explosion_timer.wait_time
	pass

func _physics_process(delta: float) -> void:
	
	progress_bar.value = explosion_timer.wait_time - explosion_timer.time_left
	
	if bounces == 3:
		velocity = Vector2.ZERO
	
	velocity += get_gravity() * delta
	
	var collision := move_and_collide(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.get_normal())
		bounces += 1
		velocity = velocity/2
		if explosion_timer.paused:
			explosion_timer.paused = false
			explosion_timer.start()

func _on_explosion_timer_timeout() -> void:
	var new_explosion = EXPLOSION.instantiate()
	new_explosion.global_position = global_position
	get_tree().get_root().add_child(new_explosion)
	new_explosion.explode()
	queue_free()
