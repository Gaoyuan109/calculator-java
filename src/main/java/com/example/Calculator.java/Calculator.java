package com.example;

public class Calculator {

    public int add(int a, int b) {
        return a + b;
    }

    public int subtract(int a, int b) {
        return a - b;
    }

    public int multiply(int a, int b) {
        return a * b;
    }

    public double divide(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("Division by zero");
        }
        return (double) a / b;
    }

    // CLI entry point so the packaged jar can be executed inside a Docker container.
    // Usage: java -jar calculator.jar <+|-|*|/> <a> <b>
    public static void main(String[] args) {
        if (args.length != 3) {
            System.err.println("Usage: java -jar calculator.jar <+|-|*|/> <a> <b>");
            System.exit(1);
        }
        String op = args[0];
        int a;
        int b;
        try {
            a = Integer.parseInt(args[1]);
            b = Integer.parseInt(args[2]);
        } catch (NumberFormatException e) {
            System.err.println("Error: operands must be integers");
            System.exit(1);
            return;
        }
        Calculator calc = new Calculator();
        switch (op) {
            case "+":
                System.out.println(a + " + " + b + " = " + calc.add(a, b));
                break;
            case "-":
                System.out.println(a + " - " + b + " = " + calc.subtract(a, b));
                break;
            case "*":
                System.out.println(a + " * " + b + " = " + calc.multiply(a, b));
                break;
            case "/":
                try {
                    System.out.println(a + " / " + b + " = " + calc.divide(a, b));
                } catch (ArithmeticException e) {
                    System.out.println("Error: " + e.getMessage());
                    System.exit(2);
                }
                break;
            default:
                System.err.println("Unknown operator: " + op);
                System.exit(1);
        }
    }
}
