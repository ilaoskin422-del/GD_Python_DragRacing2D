extends Node2D

var road_rect: ColorRect
var lines_list = []
var player_node = null
var scroll_speed = 0

func _ready():
	create_road()
	create_lines()
	
	# Находим игрока после загрузки сцены
	await get_tree().process_frame
	player_node = get_tree().get_first_node_in_group("player")

func create_road():
	# Дорога с градиентом
	road_rect = ColorRect.new()
	road_rect.size = Vector2(300, 1080)
	road_rect.position = Vector2(250, 0)
	road_rect.color = Color(0.15, 0.15, 0.2)
	add_child(road_rect)
	

func create_lines():
	# Полосы движения
	for i in range(20):
		var line = ColorRect.new()
		line.size = Vector2(10, 40)
		line.position = Vector2(395, i * 80)
		line.color = Color(1, 1, 1)
		add_child(line)
		lines_list.append(line)

func _process(delta):
	# Проверяем что игрок существует и гонка активна
	if not player_node:
		return
	
	if not player_node.race_active:
		return
	
	scroll_speed = player_node.get_current_speed() * delta * 0.5
	
	for line in lines_list:
		line.position.y += scroll_speed
		if line.position.y > 1080:
			line.position.y = -40
