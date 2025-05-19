# Music Playlist Program with Linked Lists
An implementation of a music playlist manager using linked list data structures.

## Overview
This project simulates an online music streaming application where users have personal playlists and the system tracks the most popular songs. The implementation uses circular doubly linked lists for user playlists and linked lists for tracking song statistics.

## Problem Description
The application manages:

N songs, each with a name and duration
K users, each with a personal playlist containing a small subset of songs (M<<N)
Playback simulation with random jumps through playlists
Tracking of the most played songs

## Implementation Details
The solution uses several linked list implementations:

Circular doubly linked lists for user playlists
Singly linked lists for tracking top songs
Custom data structures for songs, users, and listening statistics

## Simulation Process

Create N songs with random durations
Create K users with random playlists

For each user:

Start at a random position in their playlist
Play songs by jumping forward/backward based on random jump values
Track each played song in the top songs list


Sort the top songs list by play count and total duration
Display the top 10 most popular songs

## Course Information
- **Course**: BLM2512 - Data Structures and Algorithms
- **Semester**: Spring 2024-2025
- **Assignment**: Homework 2