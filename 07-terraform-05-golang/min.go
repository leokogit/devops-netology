package main

import "fmt"

func main() {

	var a = []int{49,333,54,11,33,44,3,112,90,50,9,}
	min := findMin(a)
	fmt.Println("Min: ", min)
}

func findMin(a []int) (min int) {
	min = a[0]
	for _, value := range a {
		if value < min {
			min = value
		}
	}
	return min
}
