# Capacity Review App

This is a simple resource management tool built with Sinatra. It allows you to manage projects, and project allocations.

## Features

*   CRUD for Projects
*   Track team capacity and allocations

## Tech Stack

*   **Backend:** Ruby, Sinatra, ActiveRecord
*   **Database:** SQLite
*   **Containerization:** Docker
*   **Deployment:** Google Cloud Run

## Getting Started

### Prerequisites

*   Docker and Docker Compose
*   Google Cloud SDK (for deployment)

### Development

To run the application locally, you can use Docker Compose:

```bash
docker-compose up --build
```

This will build the Docker image, install the dependencies, run the database migrations, and start the application. The app will be available at [http://localhost:8080](http://localhost:8080).

The main endpoints are:
- `/projects`
- `/capacities`
- `/project_allocations`
- `/analytics`

### Database

The application uses SQLite as its database. The database file is located at `db/development.sqlite3`.

When the application starts, it automatically runs the database migrations. You can find the migration files in the `db/migrate` directory.

### Deployment

The application is configured for deployment to Google Cloud Run. The `deploy.sh` script automates the process.

Before running the script, make sure you have:
1.  Authenticated with gcloud CLI.
2.  Set the project ID in your gcloud config.
3.  Enabled the Cloud Build and Cloud Run APIs.

To deploy the application, run the following command:

```bash
./deploy.sh
```

This script will:
1.  Create a Cloud Storage bucket for the database if it doesn't exist.
2.  Build and push the Docker image to Google Container Registry.
3.  Deploy the application to Cloud Run.
4.  Create a service account and grant it the necessary permissions.

## Project Structure

```
.
├── app
│   ├── controllers   # Sinatra controllers
│   ├── models        # ActiveRecord models
│   └── views         # ERB templates
├── db
│   └── migrate       # Database migrations
├── public            # Static assets
├── Gemfile           # Ruby dependencies
├── Dockerfile        # Development Dockerfile
├── Dockerfile.prod   # Production Dockerfile
├── docker-compose.yml # Docker Compose configuration
└── deploy.sh         # Deployment script
```
