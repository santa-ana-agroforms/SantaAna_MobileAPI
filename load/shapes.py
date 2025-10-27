import time
from locust import LoadTestShape

class StageShape(LoadTestShape):
    stages = [
        {"duration": 120, "users": 50,  "spawn_rate": 5},
        {"duration": 420, "users": 50,  "spawn_rate": 1},
        {"duration": 540, "users": 120, "spawn_rate": 10},
        {"duration": 720, "users": 120, "spawn_rate": 1},
        {"duration": 900, "users": 0,   "spawn_rate": 20},
    ]
    def __init__(self):
        super().__init__()
        self.start_time = time.time()

    def tick(self):
        run_time = time.time() - self.start_time
        elapsed = 0
        for s in self.stages:
            elapsed += s["duration"]
            if run_time < elapsed:
                return s["users"], s["spawn_rate"]
        return None 