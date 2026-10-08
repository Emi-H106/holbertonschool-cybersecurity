# PySniffer

![Python](https://img.shields.io/badge/Python-3.8%2B-blue)

## Description

PySniffer is a lightweight network packet sniffer built with Python and Scapy.

It captures network packets and analyzes common protocols such as TCP, UDP, and ICMP.

Main features include:

- TCP, UDP, and ICMP packet detection
- TCP port and flag information
- BPF packet filtering
- PCAP file output
- Verbose packet hex dump
- Payload string search
- Protocol statistics
- Thread and Queue-based packet processing

## Installation

Clone the repository and go to the project directory:

```bash
git clone https://github.com/Emi-H106/holbertonschool-cybersecurity.git
cd holbertonschool-cybersecurity/python_for_cyber/4x04_network_sniffer
```

Create and activate a virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
```

Install the required dependencies:

```bash
pip install -r requirements.txt
```

Packet capture may require root privileges.

## Usage

Start PySniffer:

```bash
sudo python3 sniffer.py
```

Capture packets from a specific network interface:

```bash
sudo python3 sniffer.py -i eth0
```

Use a BPF filter:

```bash
sudo python3 sniffer.py -f "tcp port 80"
```

Save captured packets to a PCAP file:

```bash
sudo python3 sniffer.py --write capture.pcap
```

Enable verbose packet output:

```bash
sudo python3 sniffer.py -v
```

Search packet payloads for a string:

```bash
sudo python3 sniffer.py -s "password"
```

Options can also be combined:

```bash
sudo python3 sniffer.py -i eth0 -f "tcp" -s "password" --write capture.pcap -v
```

Press `Ctrl+C` to stop the capture and display packet statistics.

## Architecture

PySniffer separates packet capture from packet processing using a Queue and two threads.

```text
Network
   |
   v
Sniffer Thread
   |
   v
Queue
   |
   v
Processor Thread
   |
   v
Packet Analysis
```

The sniffer thread captures packets and places them into the Queue. This keeps packet capture fast and prevents processing operations from blocking the capture process.

The processor thread retrieves packets from the Queue and performs protocol detection, payload analysis, PCAP writing, verbose output, and statistics updates.

This design improves performance by separating packet capture from packet processing.