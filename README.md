# Cities Demo Repository

This repository is a demonstration of developing containerized applications using CNCF projects, particularly showcasing the integration and utilization of selected tools in [Red Hat OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift). It serves as a practical example for developers looking to understand containerized application workflows in a cloud-native ecosystem.

[![GitHub Tag](https://img.shields.io/github/v/tag/smichard/cities_demo) "GitHub Tag"](https://github.com/smichard/cities_demo/tags)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/smichard/cities_demo) "GitHub Pull Requests"](https://github.com/smichard/cities_demo/pulls)
[![Container Registry on Quay](https://img.shields.io/badge/Quay-Container_Registry-46b9e5 "Container Registry on Quay")](https://quay.io/repository/michard/cities)
[![Developer Workspace](https://www.eclipse.org/che/contribute.svg)](https://devspaces.apps.ocp.michard.cc#https://github.com/smichard/cities_demo)

## Key Tools and Services
- **Red Hat OpenShift DevSpaces:** Streamlines the development of containerized applications.
- **Skaffold:** Facilitates continuous development for Kubernetes-native applications.
- **OpenShift Pipelines (powered by Tekton):** Provides Kubernetes-style CI/CD pipelines.
- **OpenShift GitOps (powered by Argo CD):** Implements GitOps workflows for Kubernetes.
- **GitHub:** Used as the code repository for the demo.
- **Red Hat Quay:** Serves as the container registry.

## Demo Application
The demo consists of a simple web application. It includes various index.html files, which can be permuted using a helper script (`update_script.sh`). This demonstrates code changes and their deployment process. The website is hosted using an Nginx-based container on a Kubernetes platform.

## Local Development
The container image can be built locally using Podman or Docker, providing an easy and accessible way for developers to test and modify the application.
```bash
podman build -t cities-demo-image .
```

## License

This project is licensed under the [MIT License](./LICENSE). See the LICENSE file for more details.