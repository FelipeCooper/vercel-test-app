package main

import (
	"log"
	"net/http"
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(http.StatusOK)
		writer.Write([]byte("Hello World"))
	})
	err := http.ListenAndServe(":8080", mux)
	if err != nil {
		log.Fatalf("Error in ListenAndServe: %s", err)
		return
	}
}
