package main

import (
	migrator "data-generator/cmd/migrator/psqlmigrator"
	"data-generator/config"
	"data-generator/utils"
	"database/sql"
	"embed"
	"fmt"
)

const (
	migrationsDir = "migrations"
)

//go:embed migrations/*.sql
var MigrationsFS embed.FS

func main() {
	// load mode parameter
	mode := utils.LoadMigrationMode()
	// load config
	cfg := config.EnvLoad()

	// Create Migrator
	migrator := migrator.NewMigrator(MigrationsFS, migrationsDir)

	// Get the DB instance
	connectionStr := fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable",
		cfg.User,
		cfg.Password,
		cfg.Host,
		cfg.Port,
		cfg.Db)
	conn, err := sql.Open("postgres", connectionStr)
	if err != nil {
		panic(err)
	}

	defer conn.Close()

	// Apply migrations
	err = migrator.ApplyMigrations(conn, mode)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Migrations applied!!")
}
