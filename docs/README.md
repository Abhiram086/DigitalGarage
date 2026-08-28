# Digital Garage

A next-generation vehicle management and telemetry tracking application. Digital Garage provides users with a central hub to track their vehicles' service histories, monitor predicted maintenance schedules, and interact with a futuristic 3D telemetry dashboard.

##  Project Overview

This project is divided into a high-performance **Flutter** frontend featuring advanced UI/UX animations, and a secure **Django REST Framework** backend responsible for data persistence, JWT authentication, and maintenance scheduling logic.

##  Key Features

### 1. Cinematic Onboarding & Authentication
* **Unified Auth Interface:** A fluid, single-page authentication screen using `AnimatedSize` to smoothly expand and contract registration fields without page routing or jarring cuts.
* **Smart Gate Routing:** Background validation of JWT tokens during the boot sequence to route users instantly to their garage or the login screen.

### 2. The Garage (Home Screen)
* **3D Vehicle Roster:** Vehicles are displayed as interactive cards that utilize a 3D-hinge flip animation upon loading.
* **Dynamic Assets:** Cards automatically render specific 3D models (`.glb` files) based on the registered vehicle type (e.g., Car, Motorcycle, Scooter).

### 3. Interactive Telemetry Dashboard
* **3D HUD:** An interactive, auto-rotating 3D model of the selected vehicle using `<model-viewer>`. Configured with `InteractionPromptStyle.basic` for a smooth, uninterrupted cinematic showcase.
* **System Diagnostics:** Scrollable, high-tech diagnostic cards displaying simulated telemetry data, powertrain status, and chassis alignment.
* **HUD Pointers:** Floating UI overlays anchored to the 3D model displaying stats like Engine Temp, Aero Status, Tyre Pressure, and Battery Voltage.

### 4. Vehicle Registration & Tracking (In Development)
* Multi-step form to establish vehicle baselines.
* **Identity:** Vehicle Type and Nickname.
* **Metrics:** License Plate, Registration Date, and Current Odometer reading.
* **Service Baseline:** Last service dates, oil life, and major parts replacement tracking (battery, tyres, brake pads).

---

##  Tech Stack

**Frontend (Mobile)**
* Framework: Flutter (Dart)
* 3D Rendering: `model_viewer_plus`
* Typography: `google_fonts` (Monoton, Outfit, Roboto Mono)
* State Management: Provider / Riverpod *(Planned)*

**Backend (API)**
* Framework: Django REST Framework (Python)
* Database: PostgreSQL
* Authentication: JWT (JSON Web Tokens)

---

##  Architecture & Division of Labor

To ensure parallel development, the architecture is strictly decoupled.

### Frontend Responsibilities
* Construct the multi-step "Add Vehicle" forms and empty-state UX.
* Manage local state, secure token storage (`flutter_secure_storage`), and API consumption.
* Handle dynamic 3D asset swapping and UI transitions.

### Backend Responsibilities 
* **Database Schema:** Construct relational models for `User`, `Vehicle`, and `ServiceHistory`.
* **Authentication:** Issue and validate JWTs for secure session management.
* **Business Logic:** Calculate predictive maintenance dates and service reminders based on user-provided odometer readings and timeline baselines.
* **REST Endpoints:** Expose clean JSON APIs for vehicle creation, retrieval, updating, and deletion (CRUD).

---

##  Development Roadmap

- [x] **Phase 1:** UI Prototyping & Theme Architecture (Dark minimal `#0F0F13` with neon blue accents).
- [x] **Phase 2:** Splash Screen & Seamless Auth Transitions.
- [x] **Phase 3:** 3D Vehicle Dashboard & Telemetry Layout.
- [ ] **Phase 4:** Dart Data Models & Mock Database Implementation.
- [ ] **Phase 5:** Django Backend Setup & PostgreSQL Schema Creation.
- [ ] **Phase 6:** API Integration & JWT Authentication wiring.
- [ ] **Phase 7:** Dynamic Maintenance Calculations & Push Notifications.

---

##  Getting Started (Local Development)

### Prerequisites
* Flutter SDK (>= 3.0.0)
* Android Studio or VS Code with Flutter extensions
* Python 3.x & Django *(for backend testing)*

### Installation
1. Clone the repository:
   ```bash
   git clone [https://github.com/your-username/digital-garage.git](https://github.com/your-username/digital-garage.git)
