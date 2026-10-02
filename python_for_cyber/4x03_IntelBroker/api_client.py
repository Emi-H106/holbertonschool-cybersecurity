#!/usr/bin/env python3
"""API client functions for IntelBroker."""

import asyncio
import json
from datetime import datetime, timedelta

import aiohttp
import requests


def load_cache():
    """Load cached intelligence from the JSON cache file."""
    try:
        with open("cache.json", "r", encoding="utf-8") as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


def save_cache(cache):
    """Save intelligence data to the JSON cache file."""
    with open("cache.json", "w", encoding="utf-8") as file:
        json.dump(cache, file, indent=4)


def get_cached_data(ip, cache):
    """Return cached data if it is less than one hour old."""
    if ip not in cache:
        return None

    timestamp = datetime.fromisoformat(cache[ip]["timestamp"])

    if datetime.now() - timestamp < timedelta(hours=1):
        return cache[ip]["data"]

    return None


async def fetch_api(session, url):
    """Fetch JSON data asynchronously from an API."""
    try:
        response = await session.get(url)

        if response.status != 200:
            return {"error": "Unavailable"}

        return await response.json()

    except Exception:
        return {"error": "Unavailable"}


async def gather_intel(ip):
    """Gather intelligence using cache when possible."""
    cache = load_cache()
    cached_data = get_cached_data(ip, cache)

    if cached_data is not None:
        return (
            cached_data["virustotal"],
            cached_data["shodan"],
            cached_data["abuseipdb"]
        )

    vt_url = f"http://localhost:5000/virustotal/{ip}"
    shodan_url = f"http://localhost:5000/shodan/{ip}"
    abuse_url = f"http://localhost:5000/abuseipdb/{ip}"

    semaphore = asyncio.Semaphore(5)

    async with aiohttp.ClientSession() as session:

        async def limited_fetch(url):
            async with semaphore:
                return await fetch_api(session, url)

        vt_data, shodan_data, abuse_data = await asyncio.gather(
            limited_fetch(vt_url),
            limited_fetch(shodan_url),
            limited_fetch(abuse_url)
        )

    cache[ip] = {
        "timestamp": datetime.now().isoformat(),
        "data": {
            "virustotal": vt_data,
            "shodan": shodan_data,
            "abuseipdb": abuse_data
        }
    }

    save_cache(cache)

    return vt_data, shodan_data, abuse_data


def query_virustotal(ip: str) -> dict:
    """Query VirusTotal mock API and return IP reputation data."""
    url = f"http://localhost:5000/virustotal/{ip}"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code == 200:
            return response.json()

        return {}

    except requests.exceptions.ConnectionError:
        print("[ERROR] Could not connect to VirusTotal API.")
        return {}

    except requests.exceptions.Timeout:
        print("[ERROR] VirusTotal API request timed out.")
        return {}


def query_abuseipdb(ip: str) -> dict:
    """Query AbuseIPDB mock API and return IP reputation data."""
    url = f"http://localhost:5000/abuseipdb/{ip}"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code == 200:
            return response.json()

        return {}

    except requests.exceptions.ConnectionError:
        print("[ERROR] Could not connect to AbuseIPDB API.")
        return {}

    except requests.exceptions.Timeout:
        print("[ERROR] AbuseIPDB API request timed out.")
        return {}
