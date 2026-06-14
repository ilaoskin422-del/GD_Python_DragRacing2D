import json
import os

HISTORY_FILE = "data/race_history.json"

if not os.path.exists(HISTORY_FILE):
	print("Нет данных. Сначала сыграйте гонку!")
	exit()

with open(HISTORY_FILE, "r") as f:
	history = json.load(f)

if not history:
	print("Нет данных")
	exit()

times = [r["time"] for r in history]
wins = sum(1 for r in history if r.get("won", True))
total_money = sum(r["money"] for r in history)

print("\n" + "="*40)
print("     🏁 СТАТИСТИКА ГОНОК 🏁")
print("="*40)
print(f"Всего гонок:      {len(history)}")
print(f"Лучшее время:     {min(times):.2f} сек")
print(f"Среднее время:    {sum(times)/len(times):.2f} сек")
print(f"Всего денег:      ${total_money}")
print("="*40)

print("\n📋 Последние 5 гонок:")
for r in history[-5:]:
	print(f"   Время: {r['time']:.2f} сек | Скорость: {r['speed']} | Передача: {r['gear']}")
