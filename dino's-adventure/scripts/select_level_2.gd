extends Control

@onready var lcompleted: Label = $completed
@onready var lbest_time: Label = $best_time
@onready var llast_time: Label = $last_time
@onready var lcoins: Label = $coins
@onready var play: Button = $play


var save_path = "res://savegame.cfg"
var config =ConfigFile.new()
var err = config.load(save_path)
var max_coins
var coins
var last_time
var best_time
var completed
var prev
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	set_labels()

func load_game()->void:
	max_coins = config.get_value("level2", "max_coins")
	coins = config.get_value("level2", "coins")
	last_time=float(config.get_value("level2","last_time"))
	best_time=float(config.get_value("level2","best_time"))
	completed=config.get_value("level2","completed")
	prev = config.get_value("level1","completed")

func set_labels()->void:
	if completed:
		lcompleted.text = "COMPLETED"
	else:
		lcompleted.text= "INCOMPLETE"
	lbest_time.text = "BEST TIME:"+time_to_string(best_time)
	llast_time.text = "LAST TIME:"+time_to_string(last_time)
	lcoins.text = "COINS:"+str(coins)+"/"+str(max_coins)
	if !prev:
		play.disabled = true
		play.text = "Finish Previous Level"

func time_to_string(time:float)->String:
	var msec=fmod(time,1)*1000
	var sec = fmod(time,60)
	var min = time/60
	var format_string="%02d : %02d : %02d"
	var actual_string = format_string % [min,sec,msec]
	return actual_string
	
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/select_test.tscn")

func _on_previous_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/select_level_1.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
