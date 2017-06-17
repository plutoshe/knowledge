package main

import (
	"encoding/json"
	"flag"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/plutoshe/knowledge/helper"
	"github.com/plutoshe/knowledge/services/record"
	"github.com/plutoshe/knowledge/storage/mongo"
)

var (
	fs = flag.NewFlagSet("", flag.ExitOnError)

	hl        = fs.String("http-listen", "0.0.0.0:16759", "HTTP/HTTPs Host and Port to listen on")
	mongoAddr = fs.String("mongo_address", "127.0.0.1:27017", "Specify the mongo address")
	mongoDB   = fs.String("mongo_db", "knowledge", "Specify the Mongo database")
	mongoColl = fs.String("mongo_coll", "chunk", "Specify the Mongo collection")
	relinkNum = fs.Int("relink", 5, "The number of relink")
)

func main() {
	// trail
	a := record.AddtionBody{
		Content: []record.AddtionContent{record.AddtionContent{
			Form:  "TEXT",
			Data:  "123",
			Cover: 1,
		},
			record.AddtionContent{
				Form:  "TEXT",
				Data:  "123",
				Cover: 0,
			}},
		Tag:      []string{"1", "2", "3"},
		Reminder: 1,
	}
	w, err1 := json.Marshal(a)
	log.Print(string(w), err1)
	// main
	if err := fs.Parse(os.Args[1:]); err != nil {
		log.Println(err)
		os.Exit(1)
	}

	recordStorage := mongo.NewRecordMongo(*mongoAddr, *mongoDB, *mongoColl, *relinkNum)

	mux := http.NewServeMux()
	record.AddHandler(mux, "/record", recordStorage)

	handler := helper.RequestLogger(mux)
	if handler == nil {
		log.Fatal("handler is nil, impossible")
	}
	hs := http.Server{
		Addr:         *hl,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 5 * time.Second,
		Handler:      mux,
	}
	log.Printf("main: serving HTTP on %s", hs.Addr)
	log.Fatal(hs.ListenAndServe())
}
