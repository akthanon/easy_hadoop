easy_hadoop

easy_hadoop is a collection of shell scripts designed to simplify the setup and use of Apache Hadoop in three different modes:

Standalone

Pseudo-distributed

Fully distributed

These scripts aim to save time and reduce configuration errors when working with Hadoop, whether you're experimenting locally or deploying across multiple machines.

📁 Directory Structure

easy_hadoop/
├── standalone/         # Scripts for running Hadoop in standalone mode (local)
├── pseudo-distributed/ # Scripts for pseudo-distributed setup (single-node)
└── distributed/        # Scripts for fully distributed multi-node setup

⚙️ Requirements

Bash shell

SSH installed and configured (for pseudo-distributed and distributed modes)

Java (JDK 8+)

Apache Hadoop (2.x or 3.x)

Root or sudo privileges (for some configurations)

🚀 Quick Start

1. Clone this repository

git clone https://github.com/yourusername/easy_hadoop.git
cd easy_hadoop

2. Choose a mode

Go into one of the following directories:

standalone/ — For local development or testing

pseudo-distributed/ — For simulating a cluster on a single machine

distributed/ — For running Hadoop across multiple machines

3. Run setup script

Each folder contains scripts with self-explanatory names, such as:

./install.sh          # Install dependencies
./configure.sh        # Set up Hadoop configuration files
./start_hadoop.sh     # Format HDFS and start daemons
./stop_hadoop.sh      # Stop Hadoop daemons

Please read the README.md inside each subdirectory for more specific instructions.

📚 Modes Explained

Standalone Mode

Hadoop runs as a single Java process.

Useful for development and small file testing.

Pseudo-distributed Mode

Hadoop daemons run on a single node but in separate JVMs.

Simulates a full cluster on one machine.

Distributed Mode

Hadoop runs across multiple physical or virtual machines.

Requires SSH key-based login between nodes and hostname configuration.

📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

🙌 Contributing

Feel free to submit pull requests, report issues, or suggest improvements.

📢 Contact

For questions, suggestions, or collaboration, reach out via GitHub Issues or fork the project.

Happy Hadooping! 🐘