# Easy Hadoop 🚧 (Under Construction) 🚧

easy_hadoop is a collection of scripts designed to simplify the setup and use of Apache Hadoop in three different modes:

Standalone

Pseudo-distributed

Fully distributed

These scripts aim to save time and reduce configuration errors when working with Hadoop, whether you're experimenting locally or deploying across multiple machines.

## 📁 Directory Structure

easy_hadoop/

├── standalone/         # Scripts for running Hadoop in standalone mode (local)

├── pseudo-distributed/ # Scripts for pseudo-distributed setup (single-node)

└── distributed/        # Scripts for fully distributed multi-node setup

## ⚙️ Requirements

Bash shell

SSH installed and configured (for pseudo-distributed and distributed modes)

Java (JDK 8+)

Apache Hadoop (2.x or 3.x)

Root or sudo privileges (for some configurations)

## 🚀 Quick Start

1. Clone this repository

git clone https://github.com/yourusername/easy_hadoop.git

cd easy_hadoop

2. Choose a mode

Go into one of the following directories:

standalone/ — For local development or testing

pseudo-distributed/ — For simulating a cluster on a single machine

distributed/ — For running Hadoop across multiple machines

3. Run setup script 🚧🚧🚧

```bash
git clone https://github.com/akthanon/easy_hadoop
sudo apt install default-jdk -y
sudo apt-get install ssh -y
sudo apt-get install pdsh -y

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz
tar -xzvf hadoop-3.4.1.tar.gz
mv hadoop-3.4.1 ~/hadoop

chmod +x conf_hadoop.sh
chmod +x test_hadoop_gutenberg.sh
./conf_hadoop.sh
./test_hadoop_gutenberg.sh

```
```bash
#Instalar librerias para graficar
sudo apt install python3-pip -y

# 1. Crear un entorno virtual
python3 -m venv ~/venv_hadoop

# 2. Activarlo
source ~/venv_hadoop/bin/activate

# 3. Instalar paquetes dentro del entorno
pip install matplotlib pandas

# 4. Ejecutar el script Python como siempre
python ~/graph_wordcount.py

# 5. Salir
deactivate
```
```bash
#Opcional ejecutar script
#*************************************************************************************************#
source ~/venv_hadoop/bin/activate
python ~/graf_wordcount.py
deactivate
```
## 📚 Modes Explained
```bash
| Usage Mode                  | Common Name                  | Number of Computers    |

| --------------------------- | ---------------------------- | ---------------------- |

| On a single computer        | Local Mode / Standalone Mode | 1                      |

| Simulated on one computer   | Pseudo-distributed Mode      | 1                      |

| On multiple computers       | Fully Distributed Mode       | 2 or more              |

| In the cloud                | Cloud-based Hadoop / HaaS    | Variable               |
```
## 🔁 General Recommendations  

🐧 Always use Linux (better experience than Windows).  

💻 If you don’t have multiple machines, use VirtualBox or VMware to simulate the cluster.  

🧠 Learn HDFS and MapReduce thoroughly before moving on to Hive or Spark.  

📊 Use real datasets to practice: network logs, forensic records, large CSV files, etc.  

📘 Take configuration notes: they’ll be useful in production or if you plan to teach.


## 📄 License

This project is licensed under 🚧🚧🚧. See the LICENSE file for details.

## 🙌 Contributing 🚧🚧🚧

Feel free to submit pull requests, report issues, or suggest improvements.

## 📢 Contact 

For questions, suggestions, or collaboration, reach out via GitHub Issues or fork the project.

Happy Hadooping! 🐘
