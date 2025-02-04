# QR Code Price Comparison App

This Flutter application demonstrates a **real-time price comparison** tool that uses **QR code scanning** to retrieve up-to-date pricing information from multiple online stores (eBay, plus potentially others in the future). By scanning a product's QR code, users can quickly view and compare current prices, helping them make faster, more informed purchasing decisions.

---

## Table of Contents
1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Technologies Used](#technologies-used)
4. [Getting Started](#getting-started)

---

## Overview

This project is inspired by research on QR codes and their benefits in **mobile technology**. The goal is to **streamline** how consumers compare prices across multiple platforms by scanning a single QR code. The application uses:
- **QR code scanning** to identify products.
- **APIs and web scraping** to gather real-time price data.
- **Sorting & Price Comparison Algorithm** to present the best (lowest) price options first.

By focusing on the **Flutter** framework, this app offers a **cross-platform** experience for both Android and iOS users.

---

## Key Features
**QR Code Scanning**  : Easily scan product QR codes to retrieve product details and initiate the price comparison.

**Real-Time Price Retrieval** : Leverages the eBay API (and other data sources) to fetch the latest prices.

**Sorted Price Results**  : Results are ordered to display the lowest price or best quality options first.

**Cross-Platform Compatibility** : Built using Flutter and Dart, ensuring the same codebase can run on both Android and iOS.

**Time-Saving and Cost-Efficient** : Simplifies the process of finding the best deals by aggregating prices from multiple stores in a single app.

---

## Technologies Used

- **Flutter & Dart**: Cross-platform mobile development.
- **eBay API**: Primary source for real-time pricing data.
- **Web Scraping**: For gathering product information where APIs may not be available.
- **QR Code Libraries**: For scanning and interpreting product QR codes.

---

## Getting Started

1. **Clone the repository**  
   ```bash
   git clone https://github.com/your-username/qr-price-comparison.git
   cd qr-price-comparison

2. **Install dependencies**  
   ```bash
   flutter pub get
   
3. **Configure API keys & settings**  
   In order to have the app running, you will need to get a hold of a eBay API key and a firebase project env.

4. **Run the app**  
      ```bash
   flutter run

