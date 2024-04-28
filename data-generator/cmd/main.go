package main

import (
	"data-generator/config"
	"database/sql"
	"fmt"
)

func main() {
	// get cred. from arguments or load from config file
	cfg := config.EnvLoad()

	// connection string
	conn := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.Db)
	// connect to db
	db, err := sql.Open("postgres", conn)
	if err != nil {
		fmt.Println("Open():", err)
		return
	}
	defer db.Close()

	// get all db's
	rows, err := db.Query(`SELECT datname FROM pg_database WHERE datistemplate = false`)
	if err != nil {
		fmt.Println("Query", err)
		return
	}
	for rows.Next() {
		var name string
		err = rows.Scan(&name)
		if err != nil {
			fmt.Println("Scan", err)
			return
		}
		fmt.Println("DATABASE:", name)
	}
	defer rows.Close()
	// query := `SELECT table_name FROM information_schema.tables WHERE table_schema = ORDER BY table_name`
}
