# 🚀 Automated AWS Infrastructure & Configuration Management

An end-to-end DevOps project that automates the provisioning of AWS cloud infrastructure using **Terraform** and configures the servers dynamically using **Ansible**.

---

## 🏗️ Architecture Overview

The automation pipeline provisions a two-tier architecture on AWS and manages its configuration automatically:

              +-----------------------------------+
              |        Terraform Provisioner      |
              +-----------------------------------+
                                |
        +-----------------------+-----------------------+
        |                                               |
        v                                               v
+-------------------+                           +-------------------+
|   EC2 Instance    |                           |   EC2 Instance    |
|   (Web Server)    |                           | (Database Server) |
+-------------------+                           +-------------------+
|                                               |
v                                               v
Configured via                                  Configured via
Ansible (Nginx)                             Ansible (Utility Packages)


---

## 🛠️ Tech Stack & Tools

* **Cloud Provider:** AWS (Amazon Web Services)
* **Infrastructure as Code (IaC):** Terraform
* **Configuration Management:** Ansible
* **OS Environment:** Ubuntu / WSL (Windows Subsystem for Linux)
* **Version Control:** Git & GitHub

---

## 📂 Project Structure

```text
terraform-ansible-aws-deployment/
├── terraform/
│   ├── main.tf          # Core infrastructure definitions (EC2, VPC, Security Groups)
│   ├── variables.tf     # Configurable input variables
│   ├── outputs.tf       # Exported values (Public IPs, DNS)
│   └── terraform.tfvars  # Sensitive/custom variable values (GitIgnored)
├── ansible/
│   ├── inventory.ini    # Dynamic/Static inventory configuration
│   ├── playbook.yml     # Server configuration tasks (Nginx, Packages)
│   └── ansible.cfg      # Ansible connection defaults
└── README.md            # Project documentation
