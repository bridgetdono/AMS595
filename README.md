# AMS595 Project 7
This repository contains implementations of all required components for the C/C++ Basic Syntax assignment. The project covers control flow, vectors, loops, user-defined functions, and iterative construction of Pascal’s Triangle.

## 1. Conditional Statements
This section translates a MATLAB `switch` structure into C++.  
The function reads an integer from the user and prints the corresponding case value (`-1`, `0`, or `1`), with a default response for all other inputs.

## 2. Printing a Vector
A custom function prints the elements of a `std::vector<int>` on a single line.  
C++ does not include native vector-printing functionality, so this implementation supports later tasks that return vectors.

## 3. While Loops
The Fibonacci sequence is generated beginning with the values 1 and 2.  
Terms are printed iteratively until exceeding four million, demonstrating boundary-controlled looping and arithmetic progression.

## 4. Functions

### 4.1 If Prime
A primality test is implemented using deterministic trial division.  
User input is evaluated, and the function prints whether the integer is prime.

### 4.2 Factorize
A function computes all positive factors of an integer by scanning values from 1 through the input.  
The resulting factor list is displayed using the custom vector-printing function.

### 4.3 Prime Factorization
Prime factors are extracted through repeated division by the smallest available prime.  
The function returns a complete factorization with preserved multiplicity.

## 5. Recursive Functions and Loops (Pascal’s Triangle)
The first _n_ rows of Pascal’s Triangle are generated using iterative row construction.  
Each row is derived from the previous one by summing adjacent entries, and the results are printed sequentially.
