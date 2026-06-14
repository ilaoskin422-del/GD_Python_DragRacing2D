extends Node2D

var player
var finish_line

var start_time = 0.0
var racing = false

func _ready():
	add_to_group("race_manager")
	await get_tree().process_frame
	
	player = get_tree().get_first_node_in_group("player")
	finish_line = get_node_or_null("../FinishLine")
	
	if finish_line:
		finish_line.body_entered.connect(_on_finish)
		print("FinishLine найдена")
	else:
		print("FinishLine НЕ найдена!")

func start_race():
	if player:
		racing = true
		start_time = Time.get_ticks_msec() / 1000.0
		player.start_race()

func _on_finish(body):
	if not racing:
		return
	
	if body == player:
		racing = false
		var race_time = (Time.get_ticks_msec() / 1000.0) - start_time
		player.finish_race()
		
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.show_finish_panel(race_time, 100)
		
		print("Финиш! Время: %.2f сек" % race_time)
