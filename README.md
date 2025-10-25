[![LinkedIn](https://img.shields.io/badge/Connect%20with%20me%20on-LinkedIn-blue.svg)](https://www.linkedin.com/in/gyenoch/)
[![Medium](https://img.shields.io/badge/Medium-12100E?style=for-the-badge&logo=medium&logoColor=white)](https://medium.com/@www.gyenoch)

![Screenshot 2024-09-08 045210](https://github.com/user-attachments/assets/9fa3020e-2a7d-481c-981b-82ce54ebbaf2)

## 🚀 Zero-Downtime Blue-Green Deployment with Terraform

This project demonstrates a Blue-Green Deployment strategy implemented with Terraform to achieve zero downtime application updates on AWS. The setup ensures that new releases are safely deployed, tested, and verified before switching live user traffic — all through Infrastructure as Code (IaC).

By maintaining two identical environments — Blue (live) and Green (staging) — this project enables smooth transitions between versions while minimizing deployment risks.

## 🧩 Project Structure

📁 **VPC/**

Contains Terraform configurations for setting up the foundational AWS infrastructure — including the VPC, subnets, route tables, security groups, and an Application Load Balancer (ALB).
This shared network layer serves both Blue and Green environments to ensure consistent and cost-effective resource management.

📁 **Terraform/**

Defines the core infrastructure for both Blue and Green deployments, including EC2 instances, target groups, and necessary configurations.
Each deployment is isolated but runs in the same network environment for easy switching and rollback.

📁 **Switch_Traffic/**

Contains Terraform files that handle traffic routing between Blue and Green deployments via the Application Load Balancer.
This directory allows traffic to be switched only after the new environment (Green) has been tested and confirmed stable.

## 🛠️ Tools & Technologies Used

- Terraform – Infrastructure as Code for automating AWS    resource provisioning

- AWS EC2 – Hosts the Blue and Green application environments

- AWS Application Load Balancer (ALB) – Handles intelligent traffic routing between environments

- Amazon VPC – Provides isolated networking for the deployments

## 🎯 Outcome
✅ Achieved zero-downtime deployment through Terraform
✅ Implemented automated traffic switching between Blue and Green environments
✅ Reduced deployment risks while maintaining infrastructure consistency
✅ Demonstrated real-world DevOps automation best practices

## 🧠 Key Takeaways
Blue-Green deployment enables safer and faster rollouts

Terraform’s declarative approach simplifies repeatable infrastructure creation

Modular directory design supports scalable and maintainable IaC practices


## Getting Started
To get started with this project, refer to our [comprehensive guide](https://medium.com/@www.gyenoch/zero-downtime-deployments-made-simple-blue-green-architecture-with-terraform-workspaces-8a4f997d5e1a) that walks you through infrastructure provisioning, Blue and Green deployment and more.

## Contributing
We welcome contributions! If you have ideas for enhancements or find any issues, please open a pull request or file an issue.

Happy Coding! 🚀

## 🙏 Thank You for Reading!
If you found this project insightful, don’t forget to ⭐ star the repository and connect with me on LinkedIn
 for more DevOps automation projects! 💻✨