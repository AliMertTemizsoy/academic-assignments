# Discrete-Time Convolution in MATLAB

## Overview
This project implements discrete-time convolution algorithms in MATLAB as part of the Discrete-Time Systems course at Yildiz Technical University. The implementation includes a custom convolution function, comparison with built-in functions, and audio signal processing applications.

## Project Structure
The project consists of four main implementations:

## 1. Custom Convolution Function

Implementation: Hand-coded convolution algorithm (myConv function)
Features: Takes two discrete signals and calculates their convolution without using built-in functions
File: discreteTimeConv.m

## 2. Comparison Analysis

Implementation: Comparison between custom and MATLAB's built-in convolution
Testing: Two different datasets with visual and numerical validation
Visualization: Side-by-side graphical plots showing both results

## 3. Audio Signal Processing

Implementation: Recording and processing audio signals
Data: 5-second and 10-second voice recordings
Processing: Applying both convolution methods to audio data

## 4. Echo System

Implementation: Creating echo effects with different parameters
System: y[n] = x[n] + ∑(A·k·x[n-400·k]) from k=1 to M
Testing: Three different echo configurations (M=3, M=4, M=5)
Comparison: Audio quality analysis between methods

## Components
The implementation includes the following components:

myConv Function: Core algorithm for discrete convolution
Signal Generators: Test data creation and manipulation
Visualization Tools: Graphing and comparison utilities
Audio I/O: Recording and playback functionality
Echo Generation: Implementation of the echo system equation

## Tools Used

MATLAB: Primary development environment
MATLAB Audio Toolbox: For audio recording and playback

## Results

Successful implementation of the custom convolution algorithm
Matching results between custom and built-in functions
Audible echo effects with different configurations
Visual confirmation through comparative plots

##  Course Information
- **Course**: BLM2042 - Signals and Systems
- **Semester**: Spring 2024-2025
- **Assignment**: Homework 1