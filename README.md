# NestJS Secrets Management with Infiscal, GitHub Actions, and Docker

This repository contains the code for a demonstration project showcasing how to manage secrets in a NestJS application using Infiscal, GitHub Actions, and Docker. This project was created as part of a [Medium article](https://medium.com/@christianpengu/how-do-you-manage-the-secrets-in-your-projects-a081a81aedfa) (replace with your article link!) that explores a simple approach to secrets management, versioning, and deployment.

**Key Features:**

*   **NestJS Framework:**  A progressive Node.js framework for building efficient, reliable, and scalable server-side applications.  We chose NestJS for its speed and ease of setup, allowing us to focus on the core concepts.
*   **Infiscal Integration:**  Uses [Infiscal](https://infisical.com/) to manage secrets securely outside of the codebase. Infiscal provides versioning and environment-specific secret management.
*   **GitHub Actions:**  Automates the build, testing, and deployment process using GitHub Actions.  Separate workflows are configured for development, staging, and production environments.
*   **Dockerized Application:**  The application is containerized using Docker, making it portable and easy to deploy.  Multi-stage builds are used to optimize image size for different environments.
*   **Environment-Specific Configuration:** Demonstrates how to load environment-specific configurations (using `default.yml` and environment variables) managed by Infiscal.
* **Automatic Latest Tagging**: Includes a Github Action to add the *latest* tag to the docker image on the release event.

**Project Structure:**

*   `.github/workflows/`: Contains the GitHub Actions workflow YAML files.  There are likely at least two files: one for the main CI/CD pipeline (triggered by pushes to `develop`, `staging`, and `main`) and one for tagging the `latest` image on release.
*   `src/`:  The main application code.
    *   `src/config/`:  Contains configuration files, including `configuration.ts` and the YAML files (`default.yml`, etc.).
    *   `src/app.module.ts`: The root module of the NestJS application, demonstrating the integration with `ConfigModule`.
*   `Dockerfile`: Defines how to build the Docker image.
*   `nest-cli.json`: NestJS CLI configuration file.
*   `package.json`:  Node.js project metadata, including dependencies and scripts.
*   `package-lock.json`:  Records the exact versions of dependencies used.


**Prerequisites:**

*   **Node.js and npm (or yarn):**  Make sure you have Node.js (version 16 or higher recommended) and npm (or yarn) installed.
*   **Docker and Docker Hub Account:** You'll need Docker installed locally and a Docker Hub account to push the images.
*   **Infiscal Account:** Sign up for a free Infiscal account at [infisical.com](https://infisical.com/).
*   **GitHub Account:**  A GitHub account to host the repository and use GitHub Actions.

**Getting Started:**

1.  **Clone the Repository:**
    ```bash
    git clone git@github.com:ChristianP93/infiscal-githubaction.git
    cd git@github.com:ChristianP93/infiscal-githubaction.git
    ```

2.  **Install Dependencies:**
    ```bash
    npm install  # Or yarn install
    ```

3.  **Set up Infiscal:**
    *   Create a project in Infiscal.
    *   Create the following secrets in Infiscal, scoped to the `development`, `staging`, and `production` environments:
        *   `DOCKER_HUB_USERNAME`: Your Docker Hub username.
        *   `DOCKER_HUB_TOKEN`: A Docker Hub personal access token (with write access).
        *   `ENV`: The contents of your `.env` file (see example below).  You'll have different values for each environment.
        *   `DEFAULT_YML_FILENAME`:  `default` (or whatever you name your YAML file).
        *   `IMAGE_NAME`:  The desired name for your Docker image (e.g., `your-dockerhub-username/your-image-name`).
    *  Example `.env` file content (for the `ENV` secret in Infiscal - adjust as needed):

       ```
       MY_VARIABLE=dev_value
       ```
      * Example `default.yml` (place this in `src/config/`)
        ```yaml
        my_yaml_variable: dev_yaml_value
        ```
        Modify stage and production values in Infiscal, following the article.

4.  **Configure GitHub Actions:**
    *   Create three environments in your GitHub repository settings: `development`, `staging`, and `production`.
    *  *Do not* add secrets directly to the GitHub environments. Infiscal will manage them.
    *  Integrate Infiscal and your repository using the Integration page in Infiscal.

5.  **Create Docker Hub Token:**
    *   In Docker Hub, go to your Account Settings -> Security -> Access Tokens.
    *   Create a new access token with read and write permissions. *Set an expiration date!*. You will use this token in Infiscal.

6. **Run Locally (Optional):**
      Before deploying, you might want to test locally:

    ```bash
      npm run start:dev
    ```
    This will run your application using the `development` configuration.  You'll likely need to manually set environment variables for local testing if you don't use a tool to inject them.

7.  **Push to GitHub:**
    ```bash
    git add .
    git commit -m "Initial commit"
    git push origin main  # Or your initial branch
    ```
    Pushing to `develop`, `staging`, or `main` will trigger the corresponding GitHub Action workflow, which will build and push the Docker image to Docker Hub. Creating a release on Github will trigger another workflow to tag the *latest* image

8. **Run the Docker Image:**

    After a successful build, you can run the image (replace with your actual image name and tag):
   ```bash
     docker run -d -p 3000:3000 <your-dockerhub-username>/<your-image-name>:<version>-<environment>
   #or
     docker run -d -p 3000:3000 <your-dockerhub-username>/<your-image-name>:latest