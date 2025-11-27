extends CharacterBody2D

var bunny_walking = false
var bunny_idle = false
var hunger = 100

var xdir = 1
var ydir = 1
var speed = 30

var moving_vertical_horizontal = 1 

func _ready():
	bunny_walking = true
	randomize()
	$changestatetimer.start()
	$walkingtimer.start()

func _physics_process(delta):
	update_hunger()
	
	# Reset velocity every frame
	velocity = Vector2.ZERO
	
	if bunny_walking:
		$AnimatedSprite2D.play("bunny_walking")

		if moving_vertical_horizontal == 1:
			# Horizontal movement
			velocity.x = speed * xdir
			# Sprite flip
			$AnimatedSprite2D.flip_h = xdir == -1

		elif moving_vertical_horizontal == 2:
			# Vertical movement
			velocity.y = speed * ydir

	elif bunny_idle:
		# Stop moving
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("bunny_idle")

	move_and_slide()
	
func _on_changestatetimer_timeout():
	var waittime = 1

	if bunny_walking:
		bunny_idle = true
		bunny_walking = false
		waittime = randf_range(1,5)
	else:
		bunny_walking = true
		bunny_idle = false
		waittime = randf_range(2,6)

	$changestatetimer.wait_time = waittime
	$changestatetimer.start()

func _on_walkingtimer_timeout():
	var x = randf_range(1,2)
	var y = randf_range(1,2)
	var waittime = randf_range(1,4)

	xdir = 1 if x > 1.5 else -1
	ydir = 1 if y > 1.5 else -1

	$walkingtimer.wait_time = waittime
	$walkingtimer.start()

func update_hunger():
	var hungerbar = $hungerbar
	hungerbar.value = hunger
	
	if hunger >= 100:
		hungerbar.visible = false
	else:
		hungerbar.visible = true

func _on_hunger_time_timeout():
	if hunger == 100:
		hunger -= 5
	if hunger > 100:
		hunger = 100
