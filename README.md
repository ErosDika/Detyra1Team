# PulseCore HMS Backend

ASP.NET Core 8 Web API with Clean Architecture, SQL Server, JWT auth, and Swagger.

## Requirements

- .NET 8 SDK
- SQL Server (LocalDB, Express, or full) or use the default `(localdb)\mssqllocaldb`

## Setup

1. **Connection string**  
   Default in `PulseCore.Api/appsettings.json`:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=PulseCore;Trusted_Connection=True;MultipleActiveResultSets=true"
   }
   ```
   For SQL Server Express, use `Server=.\\SQLEXPRESS;Database=PulseCore;...` and adjust as needed.

2. **JWT**  
   `Jwt:AccessSecret` in `appsettings.json` must be at least 32 characters. Change in production.

3. **Run**

   ```bash
   cd backend
   dotnet run --project PulseCore.Api
   ```

   - API: http://localhost:5000  
   - Swagger: http://localhost:5000/swagger  
   - Health: http://localhost:5000/health  

4. **Seed data**  
   On first run, migrations apply and seed data is inserted:
   - **Admin:** `admin@pulsecore.local` / `Admin123!`
   - **Clinician:** `dr.roberts@pulsecore.local` / `Clinician123!`

## API Overview

| Area        | Endpoints |
|------------|-----------|
| Auth        | `POST /api/auth/login`, `POST /api/auth/refresh`, `POST /api/auth/revoke` |
| Patients    | `GET/POST /api/patients`, `GET /api/patients/{code}` |
| Appointments| `GET/POST /api/appointments`, `PATCH /api/appointments/{id}/status` |
| Invoices    | `GET/POST /api/invoices`, `GET /api/invoices/{code}` |
| Clinical    | `GET /api/clinicalnotes/patient/{id}`, `POST /api/clinicalnotes` |
| Insurance   | `GET /api/insuranceclaims` |
| Audit       | `GET /api/audit` (Admin) |
| Roles       | `GET /api/roles/matrix` |
| Dashboard   | `GET /api/dashboard/stats`, `GET /api/dashboard/health-metrics` |

Use the access token from login in the `Authorization: Bearer <token>` header for protected endpoints.

## Solution structure

- **PulseCore.Api** – Controllers, DTOs, middleware, Program.cs
- **PulseCore.Application** – Interfaces, DTOs, services
- **PulseCore.Domain** – Entities, enums
- **PulseCore.Infrastructure** – EF Core DbContext, repositories, migrations, JWT/BCrypt
