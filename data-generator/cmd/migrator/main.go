package main

import (
	migrator "data-generator/cmd/migrator/psqlmigrator"
	"data-generator/config"
	"database/sql"
	"embed"
	"flag"
	"fmt"
)

const (
	migrationsDir = "migrations"
)

//go:embed migrations/*.sql
var MigrationsFS embed.FS

func main() {
	// load mode parameter
	mode := loadMigrationMode()
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

// loadMigrationMode load mode from parameter
func loadMigrationMode() string {
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
