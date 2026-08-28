extends Area2D

var overlapping_bodies: Array[Node2D]

func explode() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	if overlapping_bodies:
		for body in overlapping_bodies:
			if body.is_in_group("player"):
				body.knockback(global_position)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		overlapping_bodies.append(body)
		print(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		overlapping_bodies = overlapping_bodies.filter(func (x): return x != body)
