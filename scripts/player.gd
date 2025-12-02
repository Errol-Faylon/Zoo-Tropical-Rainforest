extends CharacterBody2D
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var bunny_interaction_range = false

var max_speed = 100
var last_direction := Vector2(1,0)

var tool_list = [DataTypes.Tools.None, DataTypes.Tools.Food, DataTypes.Tools.Water]
var tool_index: int = 0

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	
func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	print("Tool:", tool)

func _physics_process(_delta):
	if bunny_interaction_range:
		var bodies = $player_hitbox.get_overlapping_bodies()
		for body in bodies:
			
			# Left click interaction
			if Input.is_action_just_pressed("mouse_left"):

				# Feed — Only if FOOD tool is active
				if current_tool == DataTypes.Tools.Food and body.has_method("feed"):
					body.feed(20)
					print("You fed the bunny!")

				# Drink — Only if WATER tool is active
				if current_tool == DataTypes.Tools.Water and body.has_method("drink"):
					body.drink(15)
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

func update_tool_selection():
	ToolManager.select_tool(tool_list[tool_index])
	print("Tool switched:", tool_list[tool_index])
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		# Scroll Up → Next Tool
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			tool_index += 1
			if tool_index >= tool_list.size():
				tool_index = 0
			ToolManager.select_tool(tool_list[tool_index])

		# Scroll Down → Previous Tool
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			tool_index -= 1
			if tool_index < 0:
				tool_index = tool_list.size() - 1
			ToolManager.select_tool(tool_list[tool_index])
			
func player():
	pass
