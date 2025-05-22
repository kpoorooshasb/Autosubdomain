# Auto subdomain finder
Automated subdomain enumeration and reconnaissance script using multiple tools, designed to simplify and speed up the recon process.
This tool helps security researchers find and verify live subdomains with optional screenshot capture.

📦 Features
Discovers subdomains using:

subfinder

assetfinder

amass

gowitness

Filters and identifies alive subdomains with httprobe

Takes screenshots of alive domains using gowitness

Organizes results in a domain-based folder structure

📁 Project Structure
bash
Copy
Edit
prosubfinder/
├── install.sh         # Installs all required tools
├── prosubfinder.sh    # Main automation script
└── README.md          # Project description
🛠 How to Use
Follow these steps to get started:

1️⃣ Install Required Tools
Before running the script, make sure all dependencies are installed by running:

bash
Copy
Edit
chmod +x install.sh
./install.sh
This will install the following tools if they’re not already available:

amass

subfinder

assetfinder

httprobe

gowitness

⚠️ Make sure Go is installed and properly configured in your system’s PATH before running the install script.

2️⃣ Run the Main Script
Once installation is complete, start the subdomain recon process:

bash
Copy
Edit
chmod +x prosubfinder.sh
./prosubfinder.sh example.com
Replace example.com with the domain you want to scan.
You’ll be prompted whether you want to capture screenshots of the live subdomains.

🗂 Output Structure
bash
Copy
Edit
example.com/
├── subdomains/
│   ├── found.txt       # Combined list of discovered subdomains
│   └── alive.txt       # Live subdomains (reachable)
└── screenshots/        # Captured screenshots of live domains (optional)
