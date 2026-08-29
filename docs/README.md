# Digital Garage

A next-generation vehicle management and telemetry tracking application. Digital Garage provides users with a central hub to track their vehicles' service histories, monitor predicted maintenance schedules, and interact with a futuristic 3D telemetry dashboard.

## Project Overview

This project is divided into a high-performance Flutter frontend featuring advanced UI/UX animations, and a Django REST Framework backend responsible for data persistence, JWT authentication, and maintenance scheduling logic.

## Key Features

### 1. Cinematic Onboarding & Authentication

* Unified Auth Interface: A fluid, single-page authentication screen using AnimatedSize to smoothly expand and contract registration fields without page routing or jarring cuts.

* Smart Gate Routing: Background validation of JWT tokens during the boot sequence to route users instantly to their garage or the login screen.

### 2. The Garage (Home Screen)

* 3D Vehicle Roster: Vehicles are displayed as interactive cards that utilize a 3D-hinge flip animation upon loading.

* Dynamic Assets: Cards automatically render specific 3D models (.glb files) based on the registered vehicle type (e.g., Car, Motorcycle, Scooter).

### 3. Interactive Telemetry Dashboard

* 3D HUD: An interactive, auto-rotating 3D model of the selected vehicle using <model-viewer>. Configured with InteractionPromptStyle.basic for a smooth, uninterrupted cinematic showcase.

* System Diagnostics: Scrollable, high-tech diagnostic cards displaying simulated telemetry data, powertrain status, and chassis alignment.

* HUD Pointers: Floating UI overlays anchored to the 3D model displaying stats like Engine Temp, Aero Status, Tyre Pressure, and Battery Voltage.

### 4. Vehicle Registration & Tracking (In Development)

* Multi-step form to establish vehicle baselines.

* Identity: Vehicle Type and Nickname.

* Metrics: License Plate, Registration Date, and Current Odometer reading.

* Service Baseline: Last service dates, oil life, an
