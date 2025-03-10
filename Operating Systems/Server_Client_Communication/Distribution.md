**Team Member Assignments**

**Mahodi Hasan: Server Setup and Configuration**

- Responsible for setting up and automating the server environment, managing user accounts, and configuring services.

**Assigned Files:**

- server/server.sh – Main script to automate server setup.
- server/create-client.sh – Script to create client accounts on the server.
- server/config-sshd.sh – Script to configure SSH server and SFTP access for clients.
- server/config-site.sh – Script to set up client website directories on the server.
- **config/clients.csv** and **config/server.csv** – Used by both server and client scripts.
- **utils/ folder** – Utilities that will be shared:
  - utils/generate-pass.sh – Generates secure passwords.
  - utils/check-install.sh – Checks and installs required packages.
  - utils/fetch-info.sh – Displays system information for both server and client.
- **Dependencies**:
  - Relies on utils/check-install.sh to ensure required packages are installed.
  - Calls utils/generate-pass.sh to create secure passwords for client accounts.

**Khalid Mahmoud: Network and Security Configuration**

- Focuses on configuring network services (SSH, Mosh, NGINX) and securing remote access.

**Assigned Files:**

- server/config-mosh.sh – Script to install and configure the Mosh service for remote access.
- server/config-nginx.sh – Script to install and configure the NGINX web server.
- server/test/test-web-server.sh – Script to verify that the web server is accessible from the client.
- **Dependencies**:
  - Will use config/mosh.xml to set up Mosh configuration.
  - Works with client/test-remote.sh and client/test-web.sh for testing connectivity from clients.

**Team Member 3: Client Setup and SSH Key Management** *(Omar Qutb)*

- Responsible for setting up the client machines, handling SSH key management, and verifying connectivity.

**Assigned Files:**

- client/client.sh – Main script to automate client setup.
- client/create-keys.sh – Script to generate SSH keys on client.
- client/setup-auth.sh – Script to set up SSH key authentication for client access to server.
- client/test-remote.sh – Script to verify SSH and Mosh access from the client.
- **Dependencies**:
  - Calls utils/generate-pass.sh if a passphrase is not provided.
  - Uses utils/check-install.sh to verify that SSH and Mosh are installed on client.

**Team Member 4:(MOHAMMED ABUNADA) Client Website and Network Mapping**

- Handles website setup on client machines and tests network configuration. Also documents the project setup.

**Assigned Files:**

- client/init-site.sh – Script to initialize a Hugo site on client.
- client/publish-site.sh – Script to publish the Hugo site to the server using rsync.
- client/exec-map.sh – Script for network mapping using Nmap to identify devices on the network.
- client/test-web.sh – Script to test web server accessibility from client using w3m.
- **Dependencies**:
  - Works with server/config-site.sh to ensure the client website is accessible via NGINX on the server.
  - Uses utils/fetch-info.sh to display system info after setup.
-----
**Shared Files and Utilities**

These scripts are used across multiple parts of the project, so team members will rely on them collectively:

- **Documentation**:
  - docs/PROJECT\_REPORT.md – Detailed project report with sample outputs and explanations.
  - docs/references.md – List of references for resources used in writing scripts.


