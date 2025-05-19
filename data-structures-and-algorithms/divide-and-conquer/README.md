# Divide and Conquer Algorithm

An implementation of a divide and conquer algorithm to solve the key-lock matching problem.

## Overview
This project implements a divide and conquer solution for matching N keys to N locks without comparing keys with other keys or locks with other locks. The algorithm uses random key selection and achieves O(N*log₂N) time complexity.

## Problem Description
Given N rooms in a tower, each requiring a unique key of different sizes:

We cannot compare keys with other keys
We cannot compare locks with other locks
We can only check if a key fits a lock by trying it
We need to find which key fits which lock efficiently

## Implementation Details
The solution follows these steps:

Randomly select a pivot key
Partition the locks array into three groups: smaller than the pivot, equal to the pivot, and larger than the pivot
Use the pivot to partition the keys array similarly
The partitioning ensures that matching keys and locks align at the same positions
Recursively apply the same process to the sub-arrays

## Key Functions

partitionLocks(): Partitions the locks array around a randomly selected pivot
partitionKeys(): Partitions the keys array based on the lock pivot
quickSort(): Implements the recursive divide and conquer strategy
randomKeySelection(): Selects a random pivot for partitioning

## Input Format
The program reads input from a text file with the following format:

First line: Array size (N)
Second line: Key array elements (space-separated)
Third line: Lock array elements (space-separated)

**Example:**
6
12 3 8 10 1 4
8 4 1 12 10 3

## Output
The program displays:

Initial key and lock arrays
Step-by-step partitioning process
Selected pivots and array rearrangements
Final matched key-lock pairs

## Time Complexity
The algorithm achieves O(N*log₂N) time complexity through efficient divide and conquer strategy, meeting the assignment requirements.

## Course Information
- **Course**: BLM2512 - Data Structures and Algorithms
- **Semester**: Spring 2024-2025
- **Assignment**: Homework 1