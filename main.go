package main

import (
	"crypto/sha256"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

var (
	flags = flag.NewFlagSet("flags", flag.ExitOnError)
	salt  = flags.String("salt", "", "hash salt (considered a secret)")
)

func main() {
	flags.Parse(os.Args[1:])
	if salt == nil || *salt == "" {
		log.Fatal("salt not set")
	}

	http.HandleFunc("/", handler)

	log.Fatal(http.ListenAndServe(":80", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	val := strings.TrimLeft(r.URL.Path, "/")

	hash := sha256.New()
	hash.Write([]byte(*salt))
	hash.Write([]byte(val))

	resp := fmt.Sprintf("%X", hash.Sum(nil))

	w.Header().Set("Content-Type", "text/plain")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(resp))
}
