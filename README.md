# React CI/CD Pipeline with Jenkins, Docker, and ngrok

This project is a beginner-friendly example of how a simple React application can be automated using a complete CI/CD pipeline. It shows how code pushed to GitHub can trigger Jenkins, build the app, package it into a Docker container, and serve it using Nginx.

By the end of this guide, you should understand:
- what CI/CD means,
- how GitHub, Jenkins, Docker, and ngrok work together,
- how to run the project locally,
- and how to set up an automated build pipeline from scratch.

---

## 1. What this project does

This project takes a React app built with Vite and automates the entire process:

1. A developer pushes code to GitHub.
2. GitHub sends a webhook notification.
3. Jenkins receives the webhook and starts a pipeline.
4. Jenkins installs dependencies and builds the React app.
5. Jenkins builds a Docker image.
6. The app is served using Nginx inside the container.

This is the core idea of CI/CD:
- Continuous Integration = automatically testing and building code when changes happen.
- Continuous Delivery/Deployment = automatically packaging and preparing the app for release.

---

## 2. The tools used in this project

| Tool | Purpose |
| :--- | :--- |
| React + Vite | Frontend app framework used to build the user interface |
| GitHub | Source control and webhook trigger |
| Jenkins | Automation server that runs the pipeline |
| ngrok | Creates a public URL for local Jenkins so GitHub can reach it |
| Docker | Packages the app into a consistent container environment |
| Nginx | Serves the built React files in the container |

### Why ngrok is needed

Jenkins is running on your local machine, usually on port 8080. GitHub cannot directly access your computer unless it is publicly reachable. ngrok solves this by creating a temporary public URL that forwards traffic to your local Jenkins instance.

Think of ngrok as the bridge between the internet and your local machine.

---

## 3. Project structure

```bash
myApp/
  src/           # React source code
  package.json   # Node.js dependencies and build scripts
  vite.config.js # Vite configuration
Dockerfile       # Docker build instructions
Jenkinsfile      # CI/CD pipeline definition
README.md        # Project documentation
```

---

## 4. Prerequisites

Before starting, install these tools:

- Node.js and npm
- Docker Desktop
- Java (Jenkins requires Java)
- Jenkins
- ngrok

Make sure these are added to your system PATH.

### Verify installation

Run the following commands in your terminal:

```bash
node -v
npm -v
java -version
docker --version
ngrok --version
```

If all commands work, you are ready to continue.

---

## 5. Run the React app locally

Navigate to the frontend folder:

```bash
cd myApp
npm install
npm run dev
```

Then open the local URL shown by Vite, usually:

```bash
http://localhost:5173
```

This confirms that the React app works on your machine.

---

## 6. Build the app manually

From the project root, run:

```bash
cd myApp
npm install
npm run build
```

This creates a production build in the dist folder.

---

## 7. Build the Docker image locally

From the repository root:

```bash
docker build -t react-app:latest .
```

To verify the image was created:

```bash
docker images
```

To run the container locally:

```bash
docker run -d -p 80:80 --name react-app-container react-app:latest
```

Then open:

```bash
http://localhost
```

If you want to stop the container:

```bash
docker stop react-app-container
```

---

## 8. How the Docker setup works

The Dockerfile uses a two-stage build process:

1. Build stage
   - Uses Node.js to install dependencies and create the production build.
2. Serve stage
   - Uses Nginx to serve the final static files.

This is a best practice because it keeps the runtime image small and efficient.

The Dockerfile in this repository does the following:
- installs dependencies,
- builds the React app,
- copies the built files into an Nginx image,
- exposes port 80.

---

## 9. Jenkins pipeline explanation

The Jenkins pipeline is defined in the Jenkinsfile.

### What the pipeline does

The pipeline has two main stages:

1. Build React
   - goes into the myApp folder,
   - runs npm install,
   - runs npm run build.

2. Docker Build
   - builds the Docker image using the repository Dockerfile.

### Jenkinsfile behavior

The Jenkinsfile uses:
- agent any → Jenkins can run the pipeline on any available agent.
- tools { nodejs 'nodejs' } → tells Jenkins which Node.js installation to use.
- bat commands → Windows shell commands for running npm and docker.

Because this environment is Windows-based, the commands use bat instead of bash.

---

## 10. Step-by-step Jenkins setup

### Step 1: Install and start Jenkins

After installing Jenkins, open it in your browser:

```bash
http://localhost:8080
```

Follow the setup wizard and complete the initial configuration.

### Step 2: Configure Node.js in Jenkins

Go to:
- Manage Jenkins
- Tools

Add a NodeJS installation named:

```bash
nodejs
```

This name must match the one used in the Jenkinsfile.

### Step 3: Create a new pipeline job

In Jenkins:
- click New Item
- choose Pipeline
- give the job a name
- click OK

### Step 4: Connect the job to this repository

In the job configuration:
- choose Pipeline script from SCM
- select Git
- paste your GitHub repository URL
- make sure Jenkinsfile is in the repository root

### Step 5: Save and build

Click Save and then Build Now.

If everything is configured correctly, Jenkins will run the pipeline automatically.

---

## 11. How GitHub webhook works

A webhook is a message sent from GitHub to Jenkins whenever code is pushed.

### Why it is useful

Instead of manually triggering builds every time, GitHub can notify Jenkins automatically.

### What you need to configure in GitHub

Go to your repository settings:
- Settings
- Webhooks
- Add webhook

Use these values:
- Payload URL: your ngrok forwarding URL + /github-webhook/
- Content type: application/json
- Event: Just the push event

Example:

```bash
https://your-random-name.ngrok-free.dev/github-webhook/
```

---

## 12. ngrok setup for local Jenkins

Since Jenkins runs on your local computer, GitHub needs a public address to send webhooks.

### Start ngrok

Run:

```bash
ngrok http 8080
```

This creates a public URL that forwards requests to your local Jenkins server.

### Why this matters

Without ngrok, GitHub would not be able to reach Jenkins because localhost is only available on your own machine.

---

## 13. Useful commands reference

### Local development

```bash
cd myApp
npm install
npm run dev
```

### Production build

```bash
cd myApp
npm run build
```

### Docker commands

```bash
docker build -t react-app:latest .
docker images
docker run -d -p 80:80 --name react-app-container react-app:latest
docker ps
docker stop react-app-container
```

### Jenkins and ngrok helpers

```bash
ngrok http 8080
http://localhost:8080
where npm
```

The command where npm helps confirm that Node.js is installed and visible to Jenkins.

---

## 14. What happens when you push code

When you push a change to GitHub:

1. GitHub detects the push event.
2. The webhook sends a request to Jenkins.
3. Jenkins starts the pipeline.
4. The React app is built.
5. A Docker image is created.
6. The application is packaged for deployment.

This is the full automation flow.

---

## 15. Why this setup is valuable

This project demonstrates several important DevOps ideas:

- automation removes manual work,
- code changes can be verified quickly,
- Docker makes the environment consistent,
- Jenkins gives repeatable deployment processes,
- and ngrok helps connect local services to the outside world.

It also helps solve the common problem of “it works on my machine” by ensuring the same build environment is used every time.

---

## 16. Troubleshooting tips

### Jenkins does not start

- Check that Java is installed.
- Make sure Jenkins is running as a service or from the installed startup method.

### npm command fails in Jenkins

- Confirm Node.js is configured in Jenkins Tools.
- Verify the correct NodeJS name is used in the Jenkinsfile.
- Run where npm in the terminal to confirm Node is available.

### Docker build fails

- Ensure Docker Desktop is running.
- Check that Docker has permission to access the project files.
- Verify that the Dockerfile is in the repository root.

### GitHub webhook is not triggering Jenkins

- Check that ngrok is still running.
- Make sure the webhook URL is correct.
- Confirm that the GitHub webhook is pointing to /github-webhook/.

---

## 17. Summary

This repository is a practical introduction to modern CI/CD. It shows how a React app can be built, containerized, and automated using:

- GitHub for source control,
- Jenkins for automation,
- ngrok for exposing local Jenkins,
- Docker for containerization,
- and Nginx for serving the app.

If you are new to DevOps, this project is a great starting point because it teaches the flow in a simple and visual way.

---

## 18. Recommended learning flow

If you are a beginner, follow these steps in order:

1. Run the React app locally.
2. Build the app manually.
3. Build the Docker image locally.
4. Set up Jenkins.
5. Configure Node.js in Jenkins.
6. Configure GitHub webhook.
7. Start ngrok.
8. Run the pipeline and observe the build.

That sequence will help you understand each layer of the system clearly.
