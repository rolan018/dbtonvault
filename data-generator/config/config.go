package config

import (
	"flag"
	"os"
	"reflect"
	"strconv"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Host     string `yaml:"host" env-required:"true"`
	Port     int    `yaml:"port" env-required:"true"`
	User     string `yaml:"user" env-required:"true"`
	Password string `yaml:"password" env-required:"true"`
	Db       string `yaml:"db" env-required:"true"`
}

func (c Config) IsEmpty() bool {
	return reflect.DeepEqual(c, Config{})
}

func EnvLoad() *Config {
	cfg := loadArgs()
	if !cfg.IsEmpty() {
		return &cfg
	}
	path := loadConfigPath()

	if _, err := os.Stat(path); os.IsNotExist(err) {
		panic("config file doesn't exist: " + path)
	}

	if err := cleanenv.ReadConfig(path, &cfg); err != nil {
		panic("Failed to read config: " + err.Error())
	}
	return &cfg
}

// load arguments from command line
func loadArgs() Config {
	arguments := os.Args
	if len(arguments) == 1 {
		return Config{}
	}
	if len(arguments) != 6 {
		panic("please provide: hostname port username password db")
	}
	host := arguments[1]
	port, err := strconv.Atoi(arguments[2])
	if err != nil {
		panic("lease provide valid port")
	}
	user := arguments[3]
	pass := arguments[4]
	database := arguments[5]

	return Config{Host: host, Port: port, User: user, Password: pass, Db: database}
}

// Load config from path
// priority: flag -> env. -> default
func loadConfigPath() string {
	var res string

	// --config="path/to/config.yaml"
	flag.StringVar(&res, "config", "", "path to config file")
	flag.Parse()

	if res == "" {
		res = os.Getenv("CONFIG_PATH")
	}
	if res == "" {
		res = "config.yaml"
	}

	return res
}
