extends CanvasLayer

@onready var gas_button = $Control/GasButton
@onready var start_button = $Control/StartButton
@onready var speed_label = $Control/SpeedLabel

var player
func _ready():
	add_to_group("ui")
	print("MobileUI: _ready вызван")
	
	# Подключаем сигналы через код
	if gas_button:
		if gas_button.button_down.is_connected(_on_gas_button_down):
			gas_button.button_down.disconnect(_on_gas_button_down)
		if gas_button.button_up.is_connected(_on_gas_button_up):
			gas_button.button_up.disconnect(_on_gas_button_up)
		
		gas_button.button_down.connect(_on_gas_button_down)
		gas_button.button_up.connect(_on_gas_button_up)
		
		gas_button.disabled = true
		print("GasButton подключен")
	
	if start_button:
		if start_button.pressed.is_connected(_on_start_button_pressed):
			start_button.pressed.disconnect(_on_start_button_pressed)
		start_button.pressed.connect(_on_start_button_pressed)
		print("StartButton подключен")
	
	# Настраиваем управление
	if not InputMap.has_action("ui_up"):
		InputMap.add_action("ui_up")
		var up_key = InputEventKey.new()
		up_key.keycode = KEY_UP
		InputMap.action_add_event("ui_up", up_key)
		var w_key = InputEventKey.new()
		w_key.keycode = KEY_W
		InputMap.action_add_event("ui_up", w_key)
		print("Управление настроено")
	
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	print("Игрок найден: ", player != null)

func _process(_delta):
	if player and player.race_active and speed_label:
		speed_label.text = str(player.get_current_speed())

func _on_gas_button_down():
	print("Газ НАЖАТ")
	if player and player.race_active:
		Input.action_press("ui_up")

func _on_gas_button_up():
	print("Газ ОТПУЩЕН")
	Input.action_release("ui_up")

func _on_start_button_pressed():
	print("Старт НАЖАТ")
	start_button.disabled = true
	start_button.visible = false
	gas_button.disabled = false
	
	await get_tree().create_timer(1.0).timeout
	
	var race_manager = get_tree().get_first_node_in_group("race_manager")
	if race_manager:
		race_manager.start_race()
		print("Гонка запущена")
	else:
		print("RaceManager не найден!")

func show_finish_panel(time, money):
	print("Финиш! Время: %.3f сек, +%d монет" % [time, money])
	start_button.disabled = false
	start_button.visible = true
	gas_button.disabled = true
	if player:
		player.position.y = 700
		player.finish_race()

# Этот метод нужен, если на сцене есть кнопка AgainButton
func _on_again_button_pressed():
	print("Ещё раз!")
	get_tree().reload_current_scene()
