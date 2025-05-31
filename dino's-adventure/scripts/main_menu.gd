extends Control
@onready var sound: Button = $sound
var save_path = "res://savegame.cfg"
var master = AudioServer.get_bus_index("Master")
var on = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !AudioServer.is_bus_mute(master):
		sound.text = "SOUND"
	else:
		sound.text="SOUND"

func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/menus/select_test.tscn')

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/menus/credits.tscn')

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_sound_pressed() -> void:
	print(!AudioServer.is_bus_mute)
	if !AudioServer.is_bus_mute:
		sound.text = "SOUND"
	else:
		sound.text= "SOUND"
	AudioServer.set_bus_mute(master,not AudioServer.is_bus_mute(master))
	
func _on_button_5_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/menus/tutorial.tscn')

func _on_sound_2_pressed() -> void:
	var config = ConfigFile.new()
	var err = config.load(save_path)
	config.set_value("level1","last_time",0.0)
	config.set_value("level1","best_time",0.0)
	config.set_value("level1","coins",0)
	config.set_value("level1","completed",false)
	config.set_value("level2","last_time",0.0)
	config.set_value("level2","best_time",0.0)
	config.set_value("level2","coins",0)
	config.set_value("level2","completed",false)
	config.save(save_path)
