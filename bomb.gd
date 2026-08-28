extends Area2D

const EXPLOSION = preload("uid://ct43nc1ho8wgx")

var player: CharacterBody2D

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += get_gravity() * delta
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		return
		
	var new_explosion = EXPLOSION.instantiate()
	new_explosion.global_position = global_position
	get_tree().get_root().add_child(new_explosion)
	new_explosion.explode()
	queue_free()
