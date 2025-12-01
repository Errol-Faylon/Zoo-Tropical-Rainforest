extends CharacterBody2D

var bunny_interaction_range = false

var max_speed = 100
var last_direction := Vector2(1,0)

func _physics_process(_delta):
	if bunny_interaction_range:
		var bodies = $player_hitbox.get_overlapping_bodies()
		for body in bodies:
			if body.has_method("feed") and Input.is_action_just_pressed("feed_food"):
				body.feed(20)   # Restore 20 hunger
				print("You fed the bunny!")
			if body.has_method("drink") and Input.is_action_just_pressed("feed_water"):
				body.drink(15)  # Restore 15 thirst
				print("You gave water to the bunny!")
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
		play_walk_animation(direction)
	else:
		play_idle_animation(last_direction)
		
func play_walk_animation(direction):
		if direction.x > 0:
			$AnimatedSprite2D.play("walk_right")
		elif direction.x < 0:
			$AnimatedSprite2D.play("walk_left")
		elif direction.y > 0:
			$AnimatedSprite2D.play("walk_down")
		elif direction.y < 0:
			$AnimatedSprite2D.play("walk_up")

func play_idle_animation(direction):
		if direction.x > 0:
			$AnimatedSprite2D.play("idle_right")
		elif direction.x < 0:
			$AnimatedSprite2D.play("idle_left")
		elif direction.y > 0:
			$AnimatedSprite2D.play("idle_down")
		elif direction.y < 0:
			$AnimatedSprite2D.play("idle_up")

func _on_player_hitbox_body_entered(body: Node2D):
	if body.has_method("feed") or body.has_method("drink"):
		bunny_interaction_range = true

func _on_player_hitbox_body_exited(body: Node2D):
	if body.has_method("feed") or body.has_method("drink"):
		bunny_interaction_range = false

func player():
	pass
