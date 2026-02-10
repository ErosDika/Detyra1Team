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
- After ~8 seconds the browser opens http://localhost:3000.
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

1. In the project root, copy `.env.example` to `.env.local`:
   ```cmd
   copy .env.example .env.local
   ```
2. In `.env.local` set (if not already):
   ```
   NEXT_PUBLIC_API_URL=http://localhost:5000
   ```
3. Restart the frontend (`start-frontend.cmd` or `npm run dev`).

Without `NEXT_PUBLIC_API_URL`, the app still runs but uses **mock data** only.

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

| What        | URL                        |
|------------|----------------------------|
| Frontend   | http://localhost:3000      |
| Login      | http://localhost:3000/login |
| Dashboard  | http://localhost:3000/dashboard |
| Backend API | http://localhost:5000    |
| Swagger    | http://localhost:5000/swagger |
| Health     | http://localhost:5000/health |

---

## Troubleshooting

- **“npm is not recognized”** – Install Node.js LTS and close/reopen all Command Prompt windows.
- **Port 3000 already in use** – Stop the other process using port 3000 or change the Next.js port in `package.json` (e.g. `next dev -p 3001`).
- **API returns 401** – Log in at `/login` with the credentials above; the app stores the token and sends it with API requests.
- **Database errors on backend** – Ensure SQL Server (or LocalDB) is installed and the connection string in `backend/PulseCore.Api/appsettings.json` is correct. The API still starts if migration/seed fails and will use empty or seeded data when the DB is fixed.
