package main

import (
	"data-generator/config"
	"data-generator/generator"
	"data-generator/storage"
	"sync"

	"fmt"

	_ "github.com/lib/pq"
)

var (
	dateLoad = "10-01-2024"
	wg       sync.WaitGroup
	numRows  = 10_000
)

func main() {
	// get cred. from arguments or load from config file
	cfg := config.EnvLoad()
	// connection to db
	postgres, err := storage.New(cfg)
	if err != nil {
		fmt.Println("Error with:", err)
		return
	}
	// Start goroutines
	wg.Add(numRows)
	for i := 0; i < numRows; i++ {
		userNum := i
		go loadToStorage(postgres, userNum)
	}
	// wait all goroutines
	wg.Wait()
}

func loadToStorage(postgres *storage.Storage, num int) {
	defer wg.Done()
	// generate data
	user := generator.GenerateUser(num, dateLoad)
	product := generator.GenerateProduct(num, dateLoad)
	order := generator.GenerateOrder(num, dateLoad, user, product)
	// load data
	err := postgres.SaveOrder(order)
	if err != nil {
		fmt.Println("Error in loadToStorage with:", err)
		return
	}
	err = postgres.SaveProduct(product)
	if err != nil {
		fmt.Println("Error in loadToStorage with:", err)
		return
	}
	err = postgres.SaveUser(user)
	if err != nil {
		fmt.Println("Error in loadToStorage with:", err)
		return
	}
	fmt.Println("Finish load data with iteration:", num)
}
