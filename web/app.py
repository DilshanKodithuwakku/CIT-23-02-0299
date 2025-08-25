from flask import Flask
import os, psycopg2

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "apppass")
DB_NAME = os.getenv("DB_NAME", "appdb")

def get_conn():
    return psycopg2.connect(
        host=DB_HOST, port=DB_PORT, user=DB_USER,
        password=DB_PASSWORD, dbname=DB_NAME
    )

# Ensure table exists
with get_conn() as conn:
    with conn.cursor() as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS visits(
                id SERIAL PRIMARY KEY,
                seen_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        conn.commit()

@app.route("/")
def index():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO visits DEFAULT VALUES RETURNING id;")
            new_id = cur.fetchone()[0]
            conn.commit()
            cur.execute("SELECT COUNT(*) FROM visits;")
            count = cur.fetchone()[0]
    return f"Hello from Flask! This is visit #{count} (last insert id: {new_id}).\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
