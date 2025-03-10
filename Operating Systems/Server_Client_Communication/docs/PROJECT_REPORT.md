# Project Report

## Team Members (Team Caclium)
- Mahodi Sabab 
- Khalid Mahmoud
- Omar Qutb
- Mohammed Abunada 
---
## Utils Directory

The **utils** directory contains utility scripts that support the project by handling common, reusable tasks such as dependency checks, password generation, and system diagnostics. Each script is modular, making the codebase more maintainable and efficient.
---
### 1. `generate-pass.sh`

Generates a secure, random password. This script is especially useful for tasks like account creation and SSH key generation where strong passwords are required.

**Implementation**  
- The script first finds the directiry it's in so that it can run `check-install.sh` from anywhere in the system
- It then runs the script to install dependency
- It then generates a secure password and echos it
---
### 2. `check-intall.sh`

Used by `generate-pass.sh` and `fetch-info.sh` to check if the commands for pwgen and fastfetch exists in the systems path, if it does not exist it installs the command and executes it

**Implementation**
- The script first assigns the 2 paramenters passed to command na d package respectively
- it uses the parameters to check if the system has the command, it install if it doesn't have the command
---
### 3. `fetch-info.sh`

Uses `fastfetch` to fetch system data and displays it

- calls the script to check if `fastfetch` is installed
- uses `fastfetch` to display system data
---
### 4. `config-mosh.sh`
The `config-mosh.sh` script configures Mosh, a remote terminal application that supports roaming and intermittent connectivity.
**Implementation** 
- Dependency Installation: Ensures Mosh is installed using the package manager.
- Firewall Configuration: Copies the `mosh.xml` file to `/etc/firewalld/services/` and enables the service permanently.
---
### Challenges Faced
- Dependency Management: Ensuring all required packages (e.g., `mosh`, `firewalld`) were installed across different systems.
   **Solution: Used `check-install.sh` to streamline dependency checks and installations.**
- Firewall Configuration: Errors in copying or enabling the `mosh.xml` file initially caused the service to fail.
   **Solution: Added detailed error messages and verified file paths dynamically in the script.**

#### Client Errors: 
- During testing, we ran into problems like invalid characters in hostnames and other unexpected errors that caused the system to fail.
- Solution: We tracked down the sources of these errors, fixed them, and tested thoroughly to ensure the system worked as expected.

---
### Learning Outcomes
- Improved skills in shell scripting and managing dependencies across systems.
- Gained experience in debugging and resolving real-world issues like client-server communication problems and configuration errors.
- Learned the importance of modular code for easier maintenance and scalability.
- Developed a deeper understanding of tools like mosh, pwgen, and fastfetch.
---
Through this project, we learned a lot. We did the necessary research to solve these problems, which helped us gain valuable knowledge about creating server-client communication using shell scripting.


