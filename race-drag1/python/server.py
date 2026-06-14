import json
import os
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler

class DragRacingHandler(BaseHTTPRequestHandler):
    
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    
    def do_POST(self):
        if self.path == '/save_result':
            length = int(self.headers['Content-Length'])
            data = json.loads(self.rfile.read(length).decode('utf-8'))
            
            # Сохраняем результат
            os.makedirs('data', exist_ok=True)
            history = []
            if os.path.exists('data/race_history.json'):
                with open('data/race_history.json', 'r', encoding='utf-8') as f:
                    history = json.load(f)
            
            race = {
                'time': data['time'],
                'speed': data['speed'],
                'gear': data['gear'],
                'money': data['money'],
                'date': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            }
            history.append(race)
            
            with open('data/race_history.json', 'w', encoding='utf-8') as f:
                json.dump(history, f, indent=2)
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({'status': 'ok'}).encode())
    
    def do_GET(self):
        if self.path == '/stats':
            stats = {'races': 0, 'best_time': 0, 'money': 0}
            
            if os.path.exists('data/race_history.json'):
                with open('data/race_history.json', 'r', encoding='utf-8') as f:
                    history = json.load(f)
                if history:
                    times = [r['time'] for r in history]
                    stats = {
                        'races': len(history),
                        'best_time': min(times),
                        'money': sum(r['money'] for r in history)
                    }
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(stats).encode())

print("🚀 Запуск Drag Racing сервера...")
print("Сервер работает на http://localhost:8080")
HTTPServer(('localhost', 8080), DragRacingHandler).serve_forever()