package main

import "fmt"

func main() {
    fmt.Println("Введите m для перевода метров в футы или f для перевода футов в метры: ")
    var input string
    fmt.Scanf("%s\n", &input)
    if input == "m" {
        fmt.Println("Перевод метров в футы")
	fmt.Print("Сколько метров?: ")
    var input_m float64
    fmt.Scanf("%f", &input_m)
    output_f := input_m * 3.28084
    fmt.Println("Результат:",input_m,"метров =",output_f,"футов")
    } else if input == "f" {
        fmt.Println("Перевод футов в метры")
	fmt.Print("Сколько футов?: ")
	var input_f float64
    fmt.Scanf("%f", &input_f)
    output_m := input_f * 0.3048
    fmt.Println("Результат:",input_f,"футов =",output_m,"метров")
    } else {
        fmt.Println("Ошибка ввода")
    }
}
