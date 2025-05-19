# Business Structure using Trees
An implementation of a hierarchical organization structure using tree data structures.

## Overview
This project models a company's organizational hierarchy using tree data structures. It analyzes the personnel tree to extract key business metrics like organizational depth, employee distribution, and financial data.

## Problem Description
The application models a company with:

N employees across K different organizational levels
A hierarchical reporting structure starting with the CEO
Employee data including name, age, salary, and reporting relationships
Various metrics needed for business analysis

## Implementation Details
The solution uses a tree data structure where:

Each node represents an employee in the organization
Parent-child relationships represent reporting lines
The CEO serves as the root of the tree
Each employee maintains a reference to their manager and subordinates

## Data Structure
The implementation uses a custom tree structure with:

Employee struct as the fundamental node type
Dynamic arrays of child pointers for variable numbers of subordinates
Parent pointers for upward traversal of the hierarchy

## Analysis Process

Read employee data from an input file
Construct the organizational tree
Traverse the tree to calculate:

Total organizational levels
Employee count at each level
Managers with most direct reports
Average employee age
Total salary expenses

## Course Information
- **Course**: BLM2512 - Data Structures and Algorithms
- **Semester**: Spring 2024-2025
- **Assignment**: Homework 3