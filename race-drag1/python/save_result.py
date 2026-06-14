import json
import os
from datetime import datetime

RESULT_FILE = "data/race_result.json"
HISTORY_FILE = "data/race_history.json"

# Читаем результат гонки
with open(RESULT_FILE, "r") as f:
    race = json.load(f)

# Добавляем дату
race["date"] = datetime.now().strftime("%H:%M:%S")

# Загружаем историю
history = []
if os.path.exists(HISTORY_FILE):
    with open(HISTORY_FILE, "r") as f:
        history = json.load(f)

# Добавляем новую гонку
history.append(race)

# Сохраняем историю
with open(HISTORY_FILE, "w") as f:
    json.dump(history, f, indent=2)

# Считаем статистику
times = [r["time"] for r in history]
best_time = min(times)
avg_time = sum(times) / len(times)
total_money = sum(r["money"] for r in history)

# Генерируем HTML отчет
html = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DRAG RACING STATS</title>
    <style>
        body {{
            background: #1a1a2e;
            font-family: 'Courier New', monospace;
            padding: 30px;
        }}
        .container {{
            max-width: 800px;
            margin: 0 auto;
            background: #16213e;
            border-radius: 20px;
            padding: 30px;
            color: white;
        }}
        h1 {{ color: #e94560; text-align: center; }}
        .stats {{
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin: 30px 0;
        }}
        .card {{
            background: #0f3460;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }}
        .value {{
            font-size: 2em;
            font-weight: bold;
            color: #e94560;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }}
        th, td {{
            padding: 10px;
            border-bottom: 1px solid #0f3460;
            text-align: center;
        }}
        th {{ background: #e94560; }}
        .best {{ background: #0f3460; color: #00ff88; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>🏁 DRAG RACING STATS 🏁</h1>
        
        <div class="stats">
            <div class="card">
                <div>ГОНОК</div>
                <div class="value">{len(history)}</div>
            </div>
            <div class="card">
                <div>ЛУЧШЕЕ ВРЕМЯ</div>
                <div class="value">{best_time:.2f} сек</div>
            </div>
            <div class="card">
                <div>ДЕНЕГ</div>
                <div class="value">${total_money}</div>
            </div>
        </div>
        
        <h3>ИСТОРИЯ</h3>
        <table>
            <tr><th>#</th><th>Время</th><th>Скорость</th><th>Передача</th><th>Деньги</th></tr>
"""
for i, r in enumerate(reversed(history[-10:]), 1):
    best_class = 'class="best"' if r["time"] == best_time else ""
    html += f'<tr {best_class}><td>{i}</td><td>{r["time"]:.2f}</td><td>{r["speed"]}</td><td>{r["gear"]}</td><td>${r["money"]}</td></tr>'

html += """
        </table>
    </div>
</body>
</html>
"""

with open("reports/statistics.html", "w") as f:
    f.write(html)

print(f"✅ Гонка сохранена! Время: {race['time']:.2f} сек")
print(f"📊 Открыть отчет: reports/statistics.html")