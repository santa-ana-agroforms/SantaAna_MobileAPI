import os
import random
import time
from locust import HttpUser, task, between

BASE_PATH = os.getenv("BASE_PATH", "/api")
USERNAME  = os.getenv("USERNAME", "dahernadez")
PASSWORD  = os.getenv("PASSWORD", "diegomovil1")
API_KEY   = os.getenv("API_KEY")

class MobileAPIUser(HttpUser):
    wait_time = between(1, 3)

    def on_start(self):
        base_headers = {}
        if API_KEY:
            base_headers["x-api-key"] = API_KEY

        token = None
        for _ in range(60):  # reintentos ~60s
            try:
                with self.client.post(
                    f"{BASE_PATH}/auth/login",
                    json={"nombre_usuario": "dahernandez", "password": "diegomovil1"},
                    name="/auth/login",
                    headers=base_headers,
                    catch_response=True,
                ) as r:
                    if r.ok:
                        data = {}
                        try:
                            data = r.json() or {}
                        except Exception:
                            pass
                        token = data.get("access_token") or data.get("token")
                        print("Login exitoso")
                        if token:
                            r.success()
                            break

                print("Login fallido, reintentando...")
                    # pequeña pausa si 4xx/5xx
                time.sleep(1)
            except Exception:
                # conexión rechazada mientras arranca → esperar y reintentar
                time.sleep(1)

        self.headers = dict(base_headers)
        if token:
            self.headers["Authorization"] = f"Bearer {token}"

        # warm-up
        self.forms = []
        fr = self.client.get(f"{BASE_PATH}/forms/tree", headers=self.headers, name="/forms/tree")
        if fr.ok:
            try:
                tree = fr.json() or []
            except Exception:
                tree = []
            for cat in tree:
                for f in (cat.get("formularios") or []):
                    self.forms.append({"id": f.get("id") or f.get("form_id")})
        self.client.get(f"{BASE_PATH}/groups", headers=self.headers, name="/groups")

    @task(5)
    def get_forms_tree(self):
        self.client.get(f"{BASE_PATH}/forms/tree", headers=self.headers, name="/forms/tree")

    @task(3)
    def get_groups(self):
        self.client.get(f"{BASE_PATH}/groups", headers=self.headers, name="/groups")

    @task(2)
    def get_dataset(self):
        self.client.get(f"{BASE_PATH}/forms/datasets", headers=self.headers, name="/datasets")

    @task(1)
    def post_entry_or_sync(self):
        payload = {
            "form_id": "8e275d34-5e4e-49a3-a41d-00de176e2fc8",
            "index_version_id": "039776ce-296a-4697-a3ff-d52333fba0ca",
            "filled_at_local": "2025-10-26T00:00:00Z",
            "status": "synced",
            "fill_json": { "ok": True },
            "form_json": { "ok": True },
            "form_name": 'Form Privado'
        }
        result = self.client.post(
            f"{BASE_PATH}/forms/entries",
            headers=self.headers,
            json=payload,
            name="/forms/entries",
        )

        # Print body for debugging
        if not result.ok:
            print(f"Error posting entry: {result.status_code} - {result.text}")
        return result
