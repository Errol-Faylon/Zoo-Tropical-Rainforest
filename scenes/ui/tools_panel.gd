extends PanelContainer

@onready var tool_food: Button = $MarginContainer/HBoxContainer/ToolFood
@onready var tool_water: Button = $MarginContainer/HBoxContainer/ToolWater


func _ready():
	ToolManager.tool_selected.connect(_on_tool_changed)

func _on_tool_food_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.Food)

func _on_tool_water_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.Water)

func _on_tool_changed(tool: DataTypes.Tools) -> void:
	tool_food.button_pressed = (tool == DataTypes.Tools.Food)
	tool_water.button_pressed = (tool == DataTypes.Tools.Water)
