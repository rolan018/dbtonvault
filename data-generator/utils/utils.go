package utils

import (
	"flag"
	"strconv"
)

// LoadMigrationMode load mode from parameter
// --mode="up"
func LoadMigrationMode() string {
	var mode string
	flag.StringVar(&mode, "mode", "", "migration mode: up or down")
	flag.Parse()
	if mode == "" {
		panic("you need to define the application launch parameters: up or down")
	} else if mode != "up" && mode != "down" {
		panic("mode parameter must be up or down")
	}
	return mode
}

// LoadNumRows load num rows from parameter
// --numRows="10000"
func LoadNumRows() int {
	var numRowsFromParam string
	flag.StringVar(&numRowsFromParam, "numRows", "", "how many rows need to be loaded")
	flag.Parse()
	numRows, err := strconv.Atoi(numRowsFromParam)
	if err != nil {
		panic(err.Error())
	}
	if numRows <= 0 {
		panic("number of rows must be greater than 0")
	}
	return numRows
}
