# Run PulseCore HMS

How to run the frontend and backend and use the app.

---

## Prerequisites

- **.NET 8 SDK** – for the backend API
- **Node.js (LTS)** – for the frontend. Install from https://nodejs.org and restart your terminal if `npm` is not recognized.

---

## 1. Run both at once

**Double-click `start-app.cmd`** in the project folder.

- Two Command Prompt windows open (Backend + Frontend).
- The script waits for the API, then starts the frontend and waits for it to be ready (up to ~45 seconds) before opening the browser at http://localhost:3000.
- **Database:** The backend creates/updates the database on startup (default: **PulseCore_New** with SQL Server/LocalDB). To use a file-based DB without SQL Server, set `"Database": { "Provider": "Sqlite" }` in `backend/PulseCore.Api/appsettings.Development.json`.
- To stop: close both windows or press **Ctrl+C** in each.

---

## 2. Run backend and frontend separately

**Terminal 1 – Backend**

```cmd
cd path\to\project
start-backend.cmd
```

Wait until you see something like: *Now listening on: http://localhost:5000*.

**Terminal 2 – Frontend**

```cmd
cd path\to\project
start-frontend.cmd
```

Then open **http://localhost:3000** in your browser.

---

## 3. Connect frontend to the API

- **Frontend:** port **3000** (Next.js)
- **Backend:** port **5000** (API)

1. Copy `.env.example` to `.env.local` (done automatically by `start-app.cmd`):
   ```cmd
   copy .env.example .env.local
   ```
2. In `.env.local`, set `NEXT_PUBLIC_API_URL=http://localhost:5000` so the frontend calls the backend.
3. Restart the frontend after changing `.env.local`.

Without `NEXT_PUBLIC_API_URL`, the app uses **mock data** only.

---

## 4. Log in (to use live API data)

1. Open **http://localhost:3000**.
2. Go to **http://localhost:3000/login** (or use “Continue without login” to use mock data).
3. Use a seeded user, for example:
   - **Email:** `admin@pulsecore.local`
   - **Password:** `Admin123!`

After login you are redirected to the dashboard and the app loads **patients, appointments, invoices, audit log, roles, and system health** from the API.

---

## URLs

| What        | URL                              |
|-------------|-----------------------------------|
| Frontend    | http://localhost:3000             |
| Login       | http://localhost:3000/login      |
| Dashboard   | http://localhost:3000/dashboard  |
| Backend API | http://localhost:5000            |
| Swagger     | http://localhost:5000/swagger    |
| Health      | http://localhost:5000/health     |

---

## Database (backend) – migration and creation

- **Automatic:** When you start the backend (`start-backend.cmd` or `dotnet run`), the API **creates the database and runs migration/seed by itself**. You do not need to run migrations manually for normal use.
- **This project uses SQLite in Development:** The file `backend/PulseCore.Api/appsettings.Development.json` has `"Provider": "Sqlite"`. On first run the API creates `pulsecore.db` in the API folder and seeds it (admin user, sample data).
- **Optional – run migrations only (SQL Server):** If you use SQL Server, run `backend\create-database.cmd` to create/update the DB without starting the API.

---

## Troubleshooting

- **“npm is not recognized”** – Install Node.js LTS and close/reopen all Command Prompt windows.
- **"localhost:3000 refused to connect" / ERR_CONNECTION_REFUSED** – The frontend is not running. Run `start-app.cmd` (or `start-frontend.cmd`) and wait until the frontend is ready; first compile can take 15–30 seconds, then open http://localhost:3000.
- **Port 3000 already in use (EADDRINUSE)** – Another process (often a previous frontend) is using port 3000. Run **`free-port-3000.cmd`** to free it, then run **`start-frontend.cmd`** again. Or close the other Command Prompt window where the frontend is running. Run the frontend from the **project root** (folder with `package.json`), not from the `backend` folder.
- **API returns 401** – Log in at `/login` with the credentials above; the app stores the token and sends it with API requests.
- **Database errors on backend** – Ensure SQL Server (or LocalDB) is installed, or set `Database:Provider` to `Sqlite` in `appsettings.Development.json`. The API still starts if migration/seed fails and will use empty or seeded data when the DB is fixed.
