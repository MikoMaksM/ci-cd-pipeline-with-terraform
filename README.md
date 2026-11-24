## Complete CI/CD with Terraform

## Technologies used:
<img width="390" height="45" alt="image" src="https://github.com/user-attachments/assets/101209fe-0183-4bc4-a541-2354fa571f8e" />

## Project Description:
Integrate provisioning stage into complete CI/CD Pipeline to automate provisioning server instead of deploying to an existing server
- Create SSH Key Pair
- Install Terraform inside Jenkins container
- Add Terraform configuration to application’s git repository
- Adjust Jenkinsfile to add “provision” step to the CI/CD pipeline that provisions EC2 instance
- Complete CI/CD project has the following configuration:
  
a) CI step: Build artifact for Java Maven application

b) CI step: Build and push Docker image to Docker Hub

c) CD step: Automatically provision EC2 instance using TF

d) CD step: Deploy new application version on the provisioned EC2 instance with Docker Compose


This project demonstrates a complete CI/CD process: from source code update to automated deployment of a Java Spring Boot application on an **AWS EC2 **instance **provisioned via Terraform**.  
Everything is orchestrated by **Jenkins**, with Docker artifacts pushed to **Docker Hub**.

---

## Components Overview

| Component | Role |
|----------|------|
| `Jenkinsfile` | Pipeline orchestration |
| `Dockerfile` | Builds the app’s Docker image |
| `docker-compose.yaml` | Launches the app and PostgreSQL on EC2 |
| `Terraform (main.tf + variables.tf)` | Automates EC2 provisioning |
| `entry-script.sh` | EC2 initialization script  |
| `server-cmds.sh` | Executed remotely by Jenkins to start the app |

---

## Jenkins Pipeline: Step-by-Step

### 1. `SCM Checkout`

**File involved:** `Jenkinsfile`  
Jenkins automatically clones the GitHab repository to retrieve configuration files and source code.

---

### 2. `Version Increment`

**Files involved:** `Jenkinsfile`, `pom.xml`  
Uses Maven plugins `build-helper` and `versions:set` to increment the app version (`1.1.3` → `1.1.4`, etc.).

```bash
mvn build-helper:parse-version versions:set -DnewVersion=...
```

---

### 3. Build the Application

**Files involved:** `Jenkinsfile`, `pom.xml`  
Maven compiles the app and packages it into a `.jar`.

```bash
mvn clean package
```

Result: `target/java-maven-app-<version>.jar`

---

### 4. Build Docker Image

 **Files involved:** `Dockerfile`

- Image is built from `amazoncorretto:8-alpine3.17-jre`
- The `.jar` is copied into `/usr/app`
- The image is tagged as `mikomaksm/demo-app:java-maven-<version>`

---

### 5. Push to Docker Hub

**File involved:** `Jenkinsfile`

- Jenkins authenticates to Docker Hub using credentials
- The image is pushed to the public registry

### 6. Provision EC2 with Terraform

**Files:** `main.tf`, `variables.tf`

Terraform creates:
- A new VPC, public subnet, internet gateway
- An EC2 instance with SSH key
- AMI: Amazon Linux 2

Jenkins retrieves the instance’s public IP.

```bash
terraform init
terraform apply --auto-approve
terraform output ec2-public_ip
```


### 7. Deploy the Application

**Files:** `docker-compose.yaml`, `server-cmds.sh`

Here’s what happens:
1. Jenkins waits a bit for EC2 to be ready
2. Sends `server-cmds.sh` and `docker-compose.yaml` to the instance
3. Executes `server-cmds.sh` via SSH

 `server-cmds.sh`:

```bash
docker login -u <user> -p <pwd>
docker-compose up -d
```

`docker-compose.yaml`:

- Starts the application image (`mikomaksm/demo-app`)
- Starts a PostgreSQL container
- Creates a private Docker network between the two


---
