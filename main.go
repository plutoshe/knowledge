package main

import (
	"flag"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/plutoshe/knowledge/api"
	"github.com/plutoshe/knowledge/helper"
	"github.com/plutoshe/knowledge/services/record"
	"github.com/plutoshe/knowledge/services/review"
	"github.com/plutoshe/knowledge/storage/mongo"
)

var (
	fs = flag.NewFlagSet("", flag.ExitOnError)

	hl             = fs.String("http-listen", "0.0.0.0:16759", "HTTP/HTTPs Host and Port to listen on")
	mongoAddr      = fs.String("mongo_address", "127.0.0.1:27017", "Specify the mongo address")
	mongoDB        = fs.String("mongo_db", "knowledge", "Specify the Mongo database")
	mongoChunkColl = fs.String("mongo_chunk_coll", "chunk", "Specify the Mongo chunk collection")
	mongoIndexColl = fs.String("mongo_index_coll", "index", "Specify the Mongo index collection")
	reviewIndex    = fs.String("review_index", "knowledge_review_index", "Review index in index collection")
	relinkNum      = fs.Int("relink", 5, "The number of relink")
	mode           = fs.String("mode", "test", "Mode")
)

func main() {
	if err := fs.Parse(os.Args[1:]); err != nil {
		log.Println(err)
		os.Exit(1)
	}
	if *mode != "test" {
		*mode = ""
	}
	recordStorage := mongo.NewRecordMongo(*mongoAddr+*mode, *mongoDB, *mongoChunkColl, *relinkNum)
	// indexStorage := mongo.NewIndexMongo(*mongoAddr, *mongoDB, *mongoIndexColl, *relinkNum)

	mux := http.NewServeMux()
	record.AddHandler(mux, api.RecordPrefix, recordStorage)
	review.AddHandler(mux, api.ReviewPrefix, recordStorage, *reviewIndex)

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
