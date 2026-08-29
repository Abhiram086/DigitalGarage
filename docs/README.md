**# Digital Garage**

A next-generation vehicle management and telemetry tracking application. Digital Garage provides users with a central hub to track their vehicles' service histories, monitor predicted maintenance schedules, and interact with a futuristic 3D telemetry dashboard.

**## Project Overview**

This project is divided into a high-performance **\*\*Flutter\*\*** frontend featuring advanced UI/UX animations, and a **\*\*Django REST Framework\*\*** backend responsible for data persistence, JWT authentication, and maintenance scheduling logic.

**## Key Features**

**### 1. Cinematic Onboarding & Authentication**

\* **\*\*Unified Auth Interface:\*\*** A fluid, single-page authentication screen using \`AnimatedSize\` to smoothly expand and contract registration fields without page routing or jarring cuts.

\* **\*\*Smart Gate Routing:\*\*** Background validation of JWT tokens during the boot sequence to route users instantly to their garage or the login screen.

**### 2. The Garage (Home Screen)**

\* **\*\*3D Vehicle Roster:\*\*** Vehicles are displayed as interactive cards that utilize a 3D-hinge flip animation upon loading.

\* **\*\*Dynamic Assets:\*\*** Cards automatically render specific 3D models (\`.glb\` files) based on the registered vehicle type (e.g., Car, Motorcycle, Scooter).

**### 3. Interactive Telemetry Dashboard**

\* **\*\*3D HUD:\*\*** An interactive, auto-rotating 3D model of the selected vehicle using \`\<model-viewer>\`. Configured with \`InteractionPromptStyle.basic\` for a smooth, uninterrupted cinematic showcase.

\* **\*\*System Diagnostics:\*\*** Scrollable, high-tech diagnostic cards displaying simulated telemetry data, powertrain status, and chassis alignment.

\* **\*\*HUD Pointers:\*\*** Floating UI overlays anchored to the 3D model displaying stats like Engine Temp, Aero Status, Tyre Pressure, and Battery Voltage.

**### 4. Vehicle Registration & Tracking (In Development)**

\* Multi-step form to establish vehicle baselines.

\* **\*\*Identity:\*\*** Vehicle Type and Nickname.

\* **\*\*Metrics:\*\*** License Plate, Registration Date, and Current Odometer reading.

\* **\*\*Service Baseline:\*\*** Last service dates, oil life, and major parts replacement tracking (battery, tyres, brake pads).

\---

**## Tech Stack**

**### Frontend (Mobile)**

\* Framework: Flutter (Dart)

\* 3D Rendering: \`model\_viewer\_plus\`

\* Typography: \`google\_fonts\` (Monoton, Outfit, Roboto Mono)

\* State Management: Provider / Riverpod *\*(Planned)\**

**### Backend (API)**

\* Framework: Django REST Framework (Python)

\* Database: PostgreSQL

\* Database Development: Docker

\* Authentication: JWT (JSON Web Tokens)

\* API Style: REST

\---

**## Architecture & Division of Labor**

The architecture is strictly decoupled so the Flutter frontend and Django backend can be developed independently.

**### Frontend Responsibilities**

\* Construct the multi-step "Add Vehicle" forms and empty-state UX.

\* Manage local state, secure token storage, and API consumption.

\* Handle dynamic 3D asset swapping and UI transitions.

\* Consume vehicle and user-vehicle APIs from the Django backend.

**### Backend Responsibilities**

\* **\*\*Database Schema:\*\*** Maintain relational models for vehicle master data and user vehicles.

\* **\*\*Vehicle Data:\*\*** Maintain vehicle makes, models, generations, engines, years, and transmission types.

\* **\*\*Authentication:\*\*** Issue and validate JWTs for secure session management. *\*(Planned)\**

\* **\*\*Business Logic:\*\*** Calculate predictive maintenance dates and service reminders based on user-provided odometer readings and timeline baselines. *\*(Planned)\**

\* **\*\*REST Endpoints:\*\*** Expose JSON APIs for vehicle selection and, eventually, vehicle creation, retrieval, updating, and deletion.

\---

**# Backend Setup**

The backend lives inside the \`backend/\` directory.

**## Backend Structure**

\`\`\`text

backend/

├── config/

├── vehicles/

│   ├── models.py

│   ├── serializers.py

│   ├── views.py

│   ├── urls.py

│   └── management/

│       └── commands/

│           └── seed\_vehicles.py

├── data/

│   └── vehicles/

│       └── vehicles.json

├── manage.py

└── ...

\`\`\`

**## Database**

PostgreSQL is currently run through Docker.

\`\`\`text

Django

   │

   ▼

Django ORM

   │

   ▼

PostgreSQL 17

   │

   ▼

Docker container: digital-garage-db

\`\`\`

The current vehicle database hierarchy is:

\`\`\`text

VehicleMake

    ↓

VehicleModel

    ↓

VehicleGeneration

    ↓

VehicleSpecification

    ├── Engine

    └── Transmission Type

         ↓

    UserVehicle

\`\`\`

**### Vehicle Models**

The current backend contains:

\* \`VehicleMake\`

\* \`VehicleModel\`

\* \`VehicleGeneration\`

\* \`Engine\`

\* \`VehicleSpecification\`

\* \`UserVehicle\`

The vehicle master data is separate from an actual user's vehicle. A \`UserVehicle\` references a \`VehicleSpecification\` and can store user-specific information such as nickname and odometer reading.

\---

**
# Authentication API

The backend uses JWT authentication.

## Register

```http
POST /api/auth/register/
```

Example request:

```json
{
    "username": "sidh",
    "email": "sidh@example.com",
    "password": "password123"
}
```

## Login

```http
POST /api/auth/login/
```

Example request:

```json
{
    "username": "sidh",
    "password": "password123"
}
```

Example response:

```json
{
    "refresh": "<refresh_token>",
    "access": "<access_token>"
}
```

For authenticated requests, send:

```http
Authorization: Bearer <access_token>
```

The backend determines the current user from the JWT. Flutter should **not** send a user ID when creating a vehicle.

## Current User

```http
GET /api/auth/me/
Authorization: Bearer <access_token>
```

## Refresh Access Token

```http
POST /api/auth/refresh/
```

Send the refresh token to obtain a new access token.

---

# User Vehicle API

These endpoints operate on the authenticated user's personal garage.

## Get all user's vehicles

```http
GET /api/vehicles/my-cars/
Authorization: Bearer <access_token>
```

Example response:

```json
[
    {
        "id": 1,
        "vehicle_specification": 3,
        "nickname": "My Swift",
        "odometer": 48200
    }
]
```

## Add a vehicle

```http
POST /api/vehicles/my-cars/
Authorization: Bearer <access_token>
Content-Type: application/json
```

Example request:

```json
{
    "vehicle_specification": 3,
    "nickname": "My Swift",
    "odometer": 48200
}
```

The `user` field must not be supplied by Flutter. Ownership is assigned from the authenticated JWT user.

## Get one vehicle

```http
GET /api/vehicles/my-cars/<id>/
Authorization: Bearer <access_token>
```

## Update a vehicle

```http
PATCH /api/vehicles/my-cars/<id>/
Authorization: Bearer <access_token>
Content-Type: application/json
```

Example:

```json
{
    "odometer": 49000
}
```

## Delete a vehicle

```http
DELETE /api/vehicles/my-cars/<id>/
Authorization: Bearer <access_token>
```

A successful deletion returns HTTP `204 No Content`.

---

# Vehicle API**

The current vehicle APIs support the Flutter **\*\*Add Vehicle\*\*** selection flow.

The frontend should progressively request data based on the user's previous selection.

**## 1. Get all vehicle makes**

\`\`\`http

GET /api/vehicles/makes/

\`\`\`

Example response:

\`\`\`json

[

  {

    "id": 1,

    "name": "Maruti Suzuki"

  },

  {

    "id": 2,

    "name": "Hyundai"

  },

  {

    "id": 3,

    "name": "Honda"

  }

]

\`\`\`

Flutter should store the selected make's \`id\`.

\---

**## 2. Get models for a make**

\`\`\`http

GET /api/vehicles/models/?make=\<MAKE\_ID>

\`\`\`

Example:

\`\`\`http

GET /api/vehicles/models/?make=3

\`\`\`

Example response:

\`\`\`json

[

  {

    "id": 7,

    "name": "City"

  }

]

\`\`\`

\---

**## 3. Get generations for a model**

\`\`\`http

GET /api/vehicles/generations/?model=\<MODEL\_ID>

\`\`\`

Example:

\`\`\`http

GET /api/vehicles/generations/?model=7

\`\`\`

Example response:

\`\`\`json

[

  {

    "id": 4,

    "name": "5th Gen",

    "year\_from": 2020,

    "year\_to": null

  }

]

\`\`\`

\---

**## 4. Get engines for a generation**

\`\`\`http

GET /api/vehicles/engines/?generation=\<GENERATION\_ID>

\`\`\`

Example:

\`\`\`http

GET /api/vehicles/engines/?generation=4

\`\`\`

Example response:

\`\`\`json

[

  {

    "id": 5,

    "name": "1.5 i-VTEC",

    "displacement\_cc": 1498,

    "fuel\_type": "Petrol",

    "aspiration": "Naturally Aspirated"

  }

]

\`\`\`

\---

**## 5. Get vehicle specifications**

Once the user has selected the generation and engine:

\`\`\`http

GET /api/vehicles/specifications/?generation=\<GENERATION\_ID>&engine=\<ENGINE\_ID>

\`\`\`

Example:

\`\`\`http

GET /api/vehicles/specifications/?generation=4&engine=5

\`\`\`

Example response:

\`\`\`json

[

  {

    "id": 12,

    "year": 2022,

    "engine": {

      "id": 5,

      "name": "1.5 i-VTEC",

      "displacement\_cc": 1498,

      "fuel\_type": "Petrol",

      "aspiration": "Naturally Aspirated"

    },

    "transmission\_type": "MANUAL"

  },

  {

    "id": 13,

    "year": 2022,

    "engine": {

      "id": 5,

      "name": "1.5 i-VTEC",

      "displacement\_cc": 1498,

      "fuel\_type": "Petrol",

      "aspiration": "Naturally Aspirated"

    },

    "transmission\_type": "AUTOMATIC"

  }

]

\`\`\`

The selected specification's \`id\` will eventually be used when creating the user's \`UserVehicle\`.

\---

**# Flutter Add Vehicle Flow**

The intended frontend flow is:

\`\`\`text

GET /api/vehicles/makes/

        │

        ▼

   Select Make

        │

        ▼

GET /api/vehicles/models/?make=\<id>

        │

        ▼

  Select Model

        │

        ▼

GET /api/vehicles/generations/?model=\<id>

        │

        ▼

 Select Generation

        │

        ▼

GET /api/vehicles/engines/?generation=\<id>

        │

        ▼

  Select Engine

        │

        ▼

GET /api/vehicles/specifications/?generation=\<id>&engine=\<id>

        │

        ▼

Select Year / Transmission

        │

        ▼

  Vehicle selected

\`\`\`

**### Important for Flutter**

Use **\*\*IDs\*\***, not names, when making subsequent API requests.

For example:

\`\`\`text

Honda

id = 3

   ↓

City

id = 7

   ↓

5th Gen

id = 4

   ↓

1.5 i-VTEC

id = 5

   ↓

Vehicle Specification

id = 12

\`\`\`

The IDs are the identifiers that should be passed to the next API request.

\---

**# Running the Backend Locally**

From the repository root:

**### 1. Start PostgreSQL**

\`\`\`bash

docker compose up -d

\`\`\`

**### 2. Enter the backend**

\`\`\`bash

cd backend

\`\`\`

**### 3. Activate the Python virtual environment**

\`\`\`bash

source .venv/bin/activate

\`\`\`

**### 4. Apply migrations**

\`\`\`bash

python manage.py migrate

\`\`\`

**### 5. Populate development vehicle data**

\`\`\`bash

python manage.py seed\_vehicles

\`\`\`

The seed command reads:

\`\`\`text

backend/data/vehicles/vehicles.json

\`\`\`

and populates the vehicle database.

**### 6. Start Django**

\`\`\`bash

python manage.py runserver

\`\`\`

The API will then be available at:

\`\`\`text

http\://127.0.0.1:8000/

\`\`\`

For example:

\`\`\`text

http\://127.0.0.1:8000/api/vehicles/makes/

\`\`\`

During development, Django REST Framework's browsable API can also be used to inspect and test the endpoints from a browser.

\---

**# Development Vehicle Data**

Vehicle master data is currently maintained in:

\`\`\`text

backend/data/vehicles/vehicles.json

\`\`\`

The database can be populated using:

\`\`\`bash

python manage.py seed\_vehicles

\`\`\`

The seed command uses Django ORM and \`get\_or\_create()\` to avoid unnecessarily duplicating existing makes, models, engines, generations, and specifications.

The seed system also generates vehicle specifications from combinations of:

\`\`\`text

Year × Engine × Transmission

\`\`\`

The current vehicle data is **\*\*development/sample data\*\*** and should be verified before being treated as authoritative production vehicle information.

\---

**# Current Development Status

```text
[x] Flutter UI prototyping
[x] Splash / authentication UI
[x] 3D vehicle dashboard

[x] Django backend setup
[x] PostgreSQL database setup
[x] PostgreSQL Docker setup
[x] Vehicle database schema
[x] Vehicle seed-data system
[x] Vehicle selection REST APIs
[x] User authentication / JWT
[x] User vehicle CRUD API

[ ] Dart API integration
[ ] Maintenance database/schema
[ ] Service history API
[ ] Maintenance prediction logic
[ ] Fuel tracking
[ ] Distance/trip tracking
[ ] Push notifications
```

---

# Development Notes**

The frontend and backend are intentionally decoupled.

Flutter should not need to know how the PostgreSQL database is structured. It should interact with the Django backend through the REST API.

Similarly, the backend should not depend on Flutter-specific UI logic.

The backend currently supports JWT authentication, vehicle selection, and user-specific vehicle CRUD. The next major backend features will build on `UserVehicle`, particularly service history, maintenance tracking, fuel costs, distance logging, and predictive maintenance.