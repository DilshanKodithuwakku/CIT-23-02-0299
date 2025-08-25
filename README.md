# CCS3308 Assignment 1 – Dockerized Two-Service Application
**Student ID:** CIT-23-02-0299  

---

## Deployment Requirements
- **Operating System:** Ubuntu (tested on Ubuntu 22.04)  
- **Installed Software:**  
  - [Docker Engine](https://docs.docker.com/engine/install/)  
  - [Docker Compose plugin](https://docs.docker.com/compose/install/)  
- **Internet access** (to pull base images: `python:3.11-slim` and `postgres:16-alpine`)  

---

## Application Description
This project implements a **two-service Dockerized application**:  

1. **Web Service (Flask)**  
   - A Python Flask web application running on port **5000**  
   - Each page refresh inserts a new row into the database  
   - Displays:  
     - Current visit count  
     - Last inserted row ID  

2. **Database Service (PostgreSQL)**  
   - A PostgreSQL container running on port **5432** (internal only)  
   - Persists data using a named Docker volume  
   - Stores all visits in a table called **`visits`**  

---

## Network and Volume Details
- **Network:** `myapp-net` → Enables isolated communication between `web` and `db` services  
- **Volume:** `myapp-pgdata` → Stores PostgreSQL data persistently, survives container restarts  

---

## Container Configuration
- **Database Container (`myapp-db`)**  
  - Image: `postgres:16-alpine`  
  - Environment:  
    - `POSTGRES_USER=appuser`  
    - `POSTGRES_PASSWORD=apppass`  
    - `POSTGRES_DB=appdb`  
  - Volume: `myapp-pgdata:/var/lib/postgresql/data`  

- **Web Container (`myapp-web-1`)**  
  - Image: `myapp-web` (custom-built from `web/Dockerfile`)  
  - Environment variables point to DB service  
  - Port Mapping: `5000:5000`  

---

## Container List
| Container Name | Image         | Port Mapping | Role         |
|----------------|---------------|--------------|--------------|
| `myapp-db`     | postgres:16   | Internal 5432| Database     |
| `myapp-web-1`  | myapp-web     | 5000:5000    | Flask Webapp |

---

## Project Structure
```
CIT-23-02-0299/
├── prepare-app.sh        # Build image, create network & volume
├── start-app.sh          # Run web + db containers
├── stop-app.sh           # Stop containers (data persists)
├── remove-app.sh         # Remove all (containers, net, image, volume)
├── README.md             # Documentation
└── web/
    ├── app.py            # Flask web app
    ├── requirements.txt  # Dependencies
    └── Dockerfile        # Web image build instructions
```

---

## Instructions

### 1. Prepare the environment
```bash
./prepare-app.sh
```

### 2. Start the application
```bash
./start-app.sh
```
Open your browser: [http://localhost:5000](http://localhost:5000)

### 3. Stop the application (keep DB data)
```bash
./stop-app.sh
```

### 4. Remove everything (delete DB data too)
```bash
./remove-app.sh
```

---

## Example Workflow
```
# Step 1: Build and prepare resources
./prepare-app.sh
[prepare] Building web image...
[prepare] Creating network...
[prepare] Creating volume...
[prepare] Done.

# Step 2: Start the application
./start-app.sh
[start] Starting database...
[start] Starting web app...
The app is available at http://localhost:5000

# Step 3: Use the application in a web browser
# → Refresh page: counter increases, DB persists data

# Step 4: Stop without losing data
./stop-app.sh
[stop] Stopping containers...

# Step 5: Completely remove all resources
./remove-app.sh
[remove] Done.
```

---

## Key Features
-  Two distinct services (Flask web + PostgreSQL DB)  
-  Persistent volume for database state  
-  Isolated Docker network for secure inter-service communication  
-  Automatic restart on failure (`--restart on-failure:5`)  
-  Clean scripts for prepare, start, stop, remove  
-  Optional `docker-compose.yaml` for simplified orchestration  

---

Public repo: [https://github.com/DilshanKodithuwakku/CIT-23-02-0299]
