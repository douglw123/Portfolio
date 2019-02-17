//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var lat:Double = 7.00000000000001
var long:Double = 7.0
var tol:Double = 1E-10

if abs(lat - long) < tol {
    print("=")
}
else{
    print("!=")
}

if lat.isEqual(to: long) {
    print("=")
}
else{
    print("!=")
}