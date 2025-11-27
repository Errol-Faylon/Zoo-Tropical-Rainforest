extends CharacterBody2D

var bunny_walking = false
var bunny_idle = false

var xdir = 1
var ydir = 1
var speed = 25

var motion = Vector2()

var moving_vertical_horizontal = 1 

var hunger = 100
var thirst = 100

func _ready():
	bunny_walking = true
	randomize()
	$changestatetimer.start()
	$walkingtimer.start()

func _physics_process(delta):
	update_hunger()
	update_thirst()
	
	motion = Vector2.ZERO
	
	if bunny_walking == true:
		$AnimatedSprite2D.play("bunny_walking")
		
		if moving_vertical_horizontal == 1:
			motion.x = speed * xdir
			motion.y = 0
			$AnimatedSprite2D.flip_h = xdir == -1
			
		elif moving_vertical_horizontal == 2:
			motion.y = speed * ydir
			motion.x = 0
			
	if bunny_idle == true:
		$AnimatedSprite2D.play("bunny_idle")
	
	velocity = motion
	move_and_slide()
				
	
func _on_changestatetimer_timeout():
	var waittime = 1

	if bunny_walking == true:
		bunny_idle = true
		bunny_walking = false
		waittime = randf_range(1,5)
	elif bunny_idle == true:
		bunny_walking = true
		bunny_idle = false
		waittime = randf_range(2,6)

	$changestatetimer.wait_time = waittime
	$changestatetimer.start()

func _on_walkingtimer_timeout():
	var x = randf_range(1,2)
	var y = randf_range(1,2)
	var waittime = randf_range(1,4)

	xdir = 1 if randf_range(1,2) > 1.5 else -1
	ydir = 1 if randf_range(1,2) > 1.5 else -1
	moving_vertical_horizontal = 1 if randf_range(1,2) > 1.5 else 2

	$walkingtimer.wait_time = randf_range(1,4)
	$walkingtimer.start()

func update_hunger():
	var hungerbar = $hungerbar
	hungerbar.value = hunger
	
	if hunger >= 100:
		hungerbar.visible = false
	else:
		hungerbar.visible = true

func _on_hunger_time_timeout():
	if hunger <= 100:
		hunger = hunger - 10
	if hunger > 100:
		hunger = 100

func update_thirst():
	var thirstbar = $thirstbar
	thirstbar.value = thirst
	
	if thirst >= 100:
		thirstbar.visible = false
	else:
		thirstbar.visible = true

func _on_thirst_timer_timeout():
	if thirst <= 100:
		thirst = thirst - 5
	if thirst > 100:
		thirst = 100
