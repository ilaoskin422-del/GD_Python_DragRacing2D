import json
import os

def generate_report():
	if not os.path.exists('data/race_history.json'):
		print("Нет данных для отчета")
		return
	
	with open('data/race_history.json', 'r', encoding='utf-8') as f:
		history = json.load(f)
	
	if not history:
		print("Нет данных для отчета")
		return
	
	times = [r['time'] for r in history]
	best = min(times)
	avg = sum(times) / len(times)
	total_money = sum(r['money'] for r in history)
	
	html = f"""<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>DRAG RACING ОТЧЕТ</title>
	<style>
		body {{
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			font-family: Arial, sans-serif;
			padding: 40px;
		}}
		.container {{
			max-width: 800px;
			margin: 0 auto;
			background: white;
			border-radius: 20px;
			padding: 30px;
		}}
		h1 {{ color: #667eea; text-align: center; }}
		.stats {{
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 15px;
			margin: 30px 0;
		}}
		.card {{
			background: #f0f0f0;
			padding: 15px;
			border-radius: 10px;
			text-align: center;
		}}
		.number {{
			font-size: 2em;
			font-weight: bold;
			color: #667eea;
		}}
		table {{
			width: 100%;
			border-collapse: collapse;
		}}
		th, td {{
			padding: 10px;
			border-bottom: 1px solid #ddd;
			text-align: center;
		}}
		th {{ background: #667eea; color: white; }}
	</style>
</head>
<body>
	<div class="container">
		<h1>🏁 DRAG RACING ОТЧЕТ 🏁</h1>
		
		<div class="stats">
			<div class="card">
				<div>ГОНОК</div>
				<div class="number">{len(history)}</div>
			</div>
			<div class="card">
				<div>ЛУЧШЕЕ ВРЕМЯ</div>
				<div class="number">{best:.2f} сек</div>
			</div>
			<div class="card">
				<div>ДЕНЕГ</div>
				<div class="number">${total_money}</div>
			</div>
		</div>
		
		<h3>ИСТОРИЯ ГОНОК</h3>
		<table>
			<tr><th>#</th><th>Время</th><th>Скорость</th><th>Передача</th><th>Деньги</th><th>Дата</th></tr>
"""
	
	for i, race in enumerate(reversed(history), 1):
		html += f"<tr><td>{i}</td><td>{race['time']:.2f}</td><td>{race['speed']}</td><td>{race['gear']}</td><td>${race['money']}</td><td>{race.get('date', '-')}</td></tr>"
	
	html += """
		</table>
	</div>
</body>
</html>
"""
	
	os.makedirs('reports', exist_ok=True)
	with open('reports/full_report.html', 'w', encoding='utf-8') as f:
		f.write(html)
	
	print("✅ Отчет создан: reports/full_report.html")

if __name__ == '__main__':
	generate_report()
