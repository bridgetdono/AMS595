#include <iostream>
#include <vector>

// 1. Conditional Statements
void conditional_example() {
    int n;

    // ask user for a number
    std::cout << "enter a number: ";
    std::cin >> n;

    // switch statement mirroring matlab behavior
    switch(n) {
        case -1:
            std::cout << "negative one\n";
            break;
        case 0:
            std::cout << "zero\n";
            break;
        case 1:
            std::cout << "positive one\n";
            break;
        default:
            std::cout << "other value\n";
            break;
    }
}

// 2. Printing a Vector
void print_vector(std::vector<int> v) {
    // loop through vector and print values on one line
    for(int i = 0; i < v.size(); i++) {
        std::cout << v[i] << " ";
    }
    std::cout << "\n";
}

// 3. While Loops
// generate terms until exceeding 4,000,000
void fibonacci_while() {
    long long a = 1;
    long long b = 2;

    // print starting terms
    std::cout << a << " " << b << " ";

    // keep generating next term until limit exceeded
    while(true) {
        long long c = a + b;
        if(c > 4000000) {
            break;
        }
        std::cout << c << " ";
        a = b;
        b = c;
    }
    std::cout << "\n";
}

// 4.1 Is Prime
// returns true if n is prime
bool isprime(int n) {
    // handle small cases
    if(n < 2) {
        return false;
    }
    if(n == 2) {
        return true;
    }
    if(n % 2 == 0) {
        return false;
    }

    // check odd divisors
    for(int i = 3; i * i <= n; i += 2) {
        if(n % i == 0) {
            return false;
        }
    }

    return true;
}

// test for isprime
void test_isprime() {
    int n;
    std::cout << "enter a number to test for primality: ";
    std::cin >> n;
    std::cout << "isprime(" << n << ") = " << isprime(n) << "\n";
}

// 4.2 Factorize
// returns all factors of n in increasing order
std::vector<int> factorize(int n) {
    std::vector<int> answer;

    // check all integers from 1 to n
    for(int i = 1; i <= n; i++) {
        // if i divides n evenly, include it
        if(n % i == 0) {
            answer.push_back(i);
        }
    }

    return answer;
}

void test_factorize() {
    int n;
    std::cout << "enter a number to factorize: ";
    std::cin >> n;
    print_vector(factorize(n));
}

// 4.3 Prime Factorization
// repeatedly divide by smallest prime factor
std::vector<int> prime_factorize(int n) {
    std::vector<int> answer;

    // factor out 2 first
    while(n % 2 == 0) {
        answer.push_back(2);
        n /= 2;
    }

    // factor out odd primes
    int p = 3;
    while(p * p <= n) {
        while(n % p == 0) {
            answer.push_back(p);
            n /= p;
        }
        p += 2; // move to next odd number
    }

    // leftover n is a prime > 2
    if(n > 1) {
        answer.push_back(n);
    }

    return answer;
}

void test_prime_factorize() {
    int n;
    std::cout << "enter a number for prime factorization: ";
    std::cin >> n;
    print_vector(prime_factorize(n));
}

// 5. Recursive Functions and Loops
// generate first n rows of Pascal's Triangle using iteration
void pascal_triangle(int n) {
    std::vector<int> row;

    // the first row is just [1]
    row.push_back(1);

    for(int i = 0; i < n; i++) {
        // print current row
        print_vector(row);

        // build next row using previous one
        std::vector<int> next;
        next.push_back(1); // every row starts with 1

        // compute interior values
        for(int j = 0; j < row.size() - 1; j++) {
            int val = row[j] + row[j+1];
            next.push_back(val);
        }

        next.push_back(1); // every row ends with 1
        row = next; // update row
    }
}

int main() {

    conditional_example();
    fibonacci_while();
    test_isprime();
    test_factorize();
    test_prime_factorize();

    int rows;
    std::cout << "enter number of rows for pascal's triangle: ";
    std::cin >> rows;
    pascal_triangle(rows);

    return 0;
}
